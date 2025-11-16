const Prescription = require('../models/Prescription.model');
const Appointment = require('../models/Appointment.model');

// @desc    Create prescription
// @route   POST /api/prescriptions
// @access  Private (Doctor only)
exports.createPrescription = async (req, res) => {
  try {
    const prescription = await Prescription.create(req.body);

    // Update appointment with prescription ID
    await Appointment.findByIdAndUpdate(
      req.body.appointmentId,
      { prescriptionId: prescription._id, status: 'completed' }
    );

    const populatedPrescription = await Prescription.findById(prescription._id)
      .populate('patientId')
      .populate('doctorId')
      .populate('appointmentId');

    res.status(201).json({
      success: true,
      message: 'Prescription created successfully',
      data: populatedPrescription
    });
  } catch (error) {
    console.error('Error creating prescription:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating prescription',
      error: error.message
    });
  }
};

// @desc    Get prescriptions for a patient
// @route   GET /api/prescriptions/patient/:patientId
// @access  Private
exports.getPatientPrescriptions = async (req, res) => {
  try {
    const prescriptions = await Prescription.find({ patientId: req.params.patientId })
      .populate({
        path: 'doctorId',
        populate: { path: 'userId', select: 'name phone' }
      })
      .sort('-issuedDate');

    res.status(200).json({
      success: true,
      count: prescriptions.length,
      data: prescriptions
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching prescriptions',
      error: error.message
    });
  }
};

// @desc    Get prescription by ID
// @route   GET /api/prescriptions/:id
// @access  Private
exports.getPrescriptionById = async (req, res) => {
  try {
    const prescription = await Prescription.findById(req.params.id)
      .populate({
        path: 'patientId',
        populate: { path: 'userId', select: 'name phone' }
      })
      .populate({
        path: 'doctorId',
        populate: { path: 'userId', select: 'name phone' }
      });

    if (!prescription) {
      return res.status(404).json({
        success: false,
        message: 'Prescription not found'
      });
    }

    res.status(200).json({
      success: true,
      data: prescription
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching prescription',
      error: error.message
    });
  }
};

// @desc    Get prescriptions created by a doctor
// @route   GET /api/prescriptions/doctor/:doctorId
// @access  Private (Doctor only)
exports.getDoctorPrescriptions = async (req, res) => {
  try {
    const prescriptions = await Prescription.find({ doctorId: req.params.doctorId })
      .populate({
        path: 'patientId',
        populate: { path: 'userId', select: 'name phone' }
      })
      .sort('-issuedDate');

    res.status(200).json({
      success: true,
      count: prescriptions.length,
      data: prescriptions
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching prescriptions',
      error: error.message
    });
  }
};
