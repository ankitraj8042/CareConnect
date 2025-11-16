const Doctor = require('../models/Doctor.model');
const User = require('../models/User.model');

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
