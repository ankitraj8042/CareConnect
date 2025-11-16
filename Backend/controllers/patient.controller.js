const Patient = require('../models/Patient.model');
const User = require('../models/User.model');

// @desc    Get patient profile
// @route   GET /api/patients/:id
// @access  Private
exports.getPatientById = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id)
      .populate('userId', 'name email phone profileImage');

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: 'Patient not found'
      });
    }

    res.status(200).json({
      success: true,
      data: patient
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching patient',
      error: error.message
    });
  }
};

// @desc    Update patient profile
// @route   PUT /api/patients/:id
// @access  Private (Patient only)
exports.updatePatient = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: 'Patient not found'
      });
    }

    // Check authorization
    if (patient.userId.toString() !== req.user.id && req.user.role !== 'doctor') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this profile'
      });
    }

    const updatedPatient = await Patient.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    ).populate('userId', 'name email phone profileImage');

    res.status(200).json({
      success: true,
      message: 'Patient profile updated successfully',
      data: updatedPatient
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating patient profile',
      error: error.message
    });
  }
};

// @desc    Add medical history entry
// @route   POST /api/patients/:id/medical-history
// @access  Private (Patient or Doctor)
exports.addMedicalHistory = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: 'Patient not found'
      });
    }

    patient.medicalHistory.push(req.body);
    await patient.save();

    res.status(201).json({
      success: true,
      message: 'Medical history added successfully',
      data: patient
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error adding medical history',
      error: error.message
    });
  }
};

// @desc    Add document
// @route   POST /api/patients/:id/documents
// @access  Private (Patient only)
exports.addDocument = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: 'Patient not found'
      });
    }

    if (patient.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized'
      });
    }

    patient.documents.push(req.body);
    await patient.save();

    res.status(201).json({
      success: true,
      message: 'Document added successfully',
      data: patient
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error adding document',
      error: error.message
    });
  }
};
