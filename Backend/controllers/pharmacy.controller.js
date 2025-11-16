const Pharmacy = require('../models/Pharmacy.model');

// @desc    Get all pharmacies
// @route   GET /api/pharmacies
// @access  Public
exports.getAllPharmacies = async (req, res) => {
  try {
    const { city, latitude, longitude, maxDistance } = req.query;
    
    let query = {};
    
    // Filter by city
    if (city) {
      query['address.city'] = new RegExp(city, 'i');
    }

    // Geospatial search (nearby pharmacies)
    if (latitude && longitude) {
      const maxDist = maxDistance || 5000; // Default 5km
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

    const pharmacies = await Pharmacy.find(query)
      .populate('userId', 'name email phone')
      .select('-inventory')
      .sort('-rating.average');

    res.status(200).json({
      success: true,
      count: pharmacies.length,
      data: pharmacies
    });
  } catch (error) {
    console.error('Error fetching pharmacies:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching pharmacies',
      error: error.message
    });
  }
};

// @desc    Get pharmacy by ID
// @route   GET /api/pharmacies/:id
// @access  Public
exports.getPharmacyById = async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findById(req.params.id)
      .populate('userId', 'name email phone');

    if (!pharmacy) {
      return res.status(404).json({
        success: false,
        message: 'Pharmacy not found'
      });
    }

    res.status(200).json({
      success: true,
      data: pharmacy
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching pharmacy',
      error: error.message
    });
  }
};

// @desc    Search medicine across pharmacies
// @route   GET /api/pharmacies/search/medicine
// @access  Public
exports.searchMedicine = async (req, res) => {
  try {
    const { medicineName, latitude, longitude } = req.query;

    if (!medicineName) {
      return res.status(400).json({
        success: false,
        message: 'Medicine name is required'
      });
    }

    let query = {
      'inventory.medicineName': new RegExp(medicineName, 'i'),
      'inventory.stock': { $gt: 0 }
    };

    // Add location filter if provided
    if (latitude && longitude) {
      query.location = {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(longitude), parseFloat(latitude)]
          },
          $maxDistance: 10000 // 10km
        }
      };
    }

    const pharmacies = await Pharmacy.find(query)
      .populate('userId', 'name phone')
      .select('pharmacyName address location inventory');

    // Filter inventory to show only matching medicines
    const results = pharmacies.map(pharmacy => {
      const matchingMedicines = pharmacy.inventory.filter(item =>
        item.medicineName.toLowerCase().includes(medicineName.toLowerCase()) &&
        item.stock > 0
      );

      return {
        pharmacyId: pharmacy._id,
        pharmacyName: pharmacy.pharmacyName,
        address: pharmacy.address,
        contact: pharmacy.userId.phone,
        medicines: matchingMedicines
      };
    }).filter(result => result.medicines.length > 0);

    res.status(200).json({
      success: true,
      count: results.length,
      data: results
    });
  } catch (error) {
    console.error('Error searching medicine:', error);
    res.status(500).json({
      success: false,
      message: 'Error searching medicine',
      error: error.message
    });
  }
};

// @desc    Add medicine to inventory
// @route   POST /api/pharmacies/:id/inventory
// @access  Private (Pharmacist only)
exports.addMedicine = async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findById(req.params.id);

    if (!pharmacy) {
      return res.status(404).json({
        success: false,
        message: 'Pharmacy not found'
      });
    }

    if (pharmacy.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized'
      });
    }

    pharmacy.inventory.push(req.body);
    await pharmacy.save();

    res.status(201).json({
      success: true,
      message: 'Medicine added to inventory',
      data: pharmacy
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error adding medicine',
      error: error.message
    });
  }
};

// @desc    Update medicine in inventory
// @route   PUT /api/pharmacies/:id/inventory/:medicineId
// @access  Private (Pharmacist only)
exports.updateMedicine = async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findById(req.params.id);

    if (!pharmacy) {
      return res.status(404).json({
        success: false,
        message: 'Pharmacy not found'
      });
    }

    if (pharmacy.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized'
      });
    }

    const medicine = pharmacy.inventory.id(req.params.medicineId);
    if (!medicine) {
      return res.status(404).json({
        success: false,
        message: 'Medicine not found in inventory'
      });
    }

    Object.assign(medicine, req.body);
    medicine.updatedAt = Date.now();
    await pharmacy.save();

    res.status(200).json({
      success: true,
      message: 'Medicine updated successfully',
      data: pharmacy
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating medicine',
      error: error.message
    });
  }
};

// @desc    Delete medicine from inventory
// @route   DELETE /api/pharmacies/:id/inventory/:medicineId
// @access  Private (Pharmacist only)
exports.deleteMedicine = async (req, res) => {
  try {
    const pharmacy = await Pharmacy.findById(req.params.id);

    if (!pharmacy) {
      return res.status(404).json({
        success: false,
        message: 'Pharmacy not found'
      });
    }

    if (pharmacy.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized'
      });
    }

    pharmacy.inventory.pull(req.params.medicineId);
    await pharmacy.save();

    res.status(200).json({
      success: true,
      message: 'Medicine removed from inventory'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting medicine',
      error: error.message
    });
  }
};
