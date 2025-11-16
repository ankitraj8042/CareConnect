const Doctor = require('../models/Doctor.model');
const User = require('../models/User.model');

// Helper function to calculate distance between two points (Haversine formula)
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Radius of Earth in kilometers
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon/2) * Math.sin(dLon/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c; // Distance in km
}

// @desc    Get nearby doctors with distance calculation
// @route   GET /api/doctors/nearby
// @access  Public
exports.getNearbyDoctors = async (req, res) => {
  try {
    const { latitude, longitude, maxDistance, specialization } = req.query;

    if (!latitude || !longitude) {
      return res.status(400).json({
        success: false,
        message: 'Latitude and longitude are required'
      });
    }

    const userLat = parseFloat(latitude);
    const userLon = parseFloat(longitude);
    const maxDist = maxDistance ? parseInt(maxDistance) * 1000 : 50000; // Convert km to meters, default 50km

    let query = {
      location: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [userLon, userLat]
          },
          $maxDistance: maxDist
        }
      }
    };

    // Filter by specialization if provided
    if (specialization) {
      query.specialization = specialization;
    }

    const doctors = await Doctor.find(query)
      .populate('userId', 'name email phone profileImage')
      .select('-availability')
      .limit(50); // Limit to 50 nearest doctors

    // Calculate distance for each doctor
    const doctorsWithDistance = doctors.map(doctor => {
      const distance = calculateDistance(
        userLat,
        userLon,
        doctor.location.coordinates[1], // latitude
        doctor.location.coordinates[0]  // longitude
      );

      return {
        ...doctor.toObject(),
        distance: parseFloat(distance.toFixed(2))
      };
    });

    // Sort by distance
    doctorsWithDistance.sort((a, b) => a.distance - b.distance);

    res.status(200).json({
      success: true,
      count: doctorsWithDistance.length,
      data: doctorsWithDistance
    });
  } catch (error) {
    console.error('Error fetching nearby doctors:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching nearby doctors',
      error: error.message
    });
  }
};

// @desc    Get all doctors with filters
// @route   GET /api/doctors
// @access  Public
exports.getAllDoctors = async (req, res) => {
  try {
    const { specialization, city, search, latitude, longitude, maxDistance } = req.query;
    
    let query = {};
    
    // Filter by specialization
    if (specialization) {
      query.specialization = specialization;
    }
    
    // Filter by city
    if (city) {
      query['address.city'] = new RegExp(city, 'i');
    }

    // Geospatial search (nearby doctors)
    if (latitude && longitude) {
      const maxDist = maxDistance || 10000; // Default 10km
      query.location = {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(longitude), parseFloat(latitude)]
          },
          $maxDistance: parseInt(maxDist)
        }
      };
    }

    const doctors = await Doctor.find(query)
      .populate('userId', 'name email phone profileImage')
      .select('-availability')
      .sort('-rating.average');

    // Search in populated user names
    let filteredDoctors = doctors;
    if (search) {
      filteredDoctors = doctors.filter(doctor => 
        doctor.userId.name.toLowerCase().includes(search.toLowerCase()) ||
        doctor.specialization.toLowerCase().includes(search.toLowerCase())
      );
    }

    res.status(200).json({
      success: true,
      count: filteredDoctors.length,
      data: filteredDoctors
    });
  } catch (error) {
    console.error('Error fetching doctors:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching doctors',
      error: error.message
    });
  }
};

// @desc    Get single doctor by ID
// @route   GET /api/doctors/:id
// @access  Public
exports.getDoctorById = async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id)
      .populate('userId', 'name email phone profileImage');

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    res.status(200).json({
      success: true,
      data: doctor
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching doctor',
      error: error.message
    });
  }
};

// @desc    Update doctor profile
// @route   PUT /api/doctors/:id
// @access  Private (Doctor only)
exports.updateDoctor = async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id);

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    // Check if the logged-in user is the owner
    if (doctor.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this profile'
      });
    }

    const updatedDoctor = await Doctor.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    ).populate('userId', 'name email phone profileImage');

    res.status(200).json({
      success: true,
      message: 'Doctor profile updated successfully',
      data: updatedDoctor
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating doctor profile',
      error: error.message
    });
  }
};

// @desc    Get doctor's availability
// @route   GET /api/doctors/:id/availability
// @access  Public
exports.getDoctorAvailability = async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id).select('availability');

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    res.status(200).json({
      success: true,
      data: doctor.availability
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching availability',
      error: error.message
    });
  }
};

// @desc    Get specializations list
// @route   GET /api/doctors/specializations/list
// @access  Public
exports.getSpecializations = async (req, res) => {
  try {
    const specializations = [
      'General Physician',
      'Cardiologist',
      'Dermatologist',
      'Pediatrician',
      'Orthopedic',
      'Neurologist',
      'Gynecologist',
      'Psychiatrist',
      'ENT Specialist',
      'Ophthalmologist',
      'Dentist',
      'Other'
    ];

    res.status(200).json({
      success: true,
      data: specializations
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching specializations',
      error: error.message
    });
  }
};
