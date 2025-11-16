const Appointment = require('../models/Appointment.model');
const Doctor = require('../models/Doctor.model');
const Patient = require('../models/Patient.model');

// @desc    Create new appointment
// @route   POST /api/appointments
// @access  Private (Patient only)
exports.createAppointment = async (req, res) => {
  try {
    const { patientId, doctorId, appointmentDate, timeSlot, chiefComplaint, notes } = req.body;

    // Verify patient exists
    const patient = await Patient.findById(patientId);
    if (!patient) {
      return res.status(404).json({
        success: false,
        message: 'Patient not found'
      });
    }

    // Verify doctor exists
    const doctor = await Doctor.findById(doctorId);
    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    // Check if time slot is already booked
    const existingAppointment = await Appointment.findOne({
      doctorId,
      appointmentDate: new Date(appointmentDate),
      'timeSlot.startTime': timeSlot.startTime,
      status: { $ne: 'cancelled' }
    });

    if (existingAppointment) {
      return res.status(400).json({
        success: false,
        message: 'This time slot is already booked'
      });
    }

    // Create appointment
    const appointment = await Appointment.create({
      patientId,
      doctorId,
      appointmentDate,
      timeSlot,
      chiefComplaint,
      notes
    });

    const populatedAppointment = await Appointment.findById(appointment._id)
      .populate('patientId')
      .populate({
        path: 'doctorId',
        populate: { path: 'userId', select: 'name phone' }
      });

    res.status(201).json({
      success: true,
      message: 'Appointment booked successfully',
      data: populatedAppointment
    });
  } catch (error) {
    console.error('Error creating appointment:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating appointment',
      error: error.message
    });
  }
};

// @desc    Get appointments for a patient
// @route   GET /api/appointments/patient/:patientId
// @access  Private (Patient only)
exports.getPatientAppointments = async (req, res) => {
  try {
    const appointments = await Appointment.find({ patientId: req.params.patientId })
      .populate({
        path: 'doctorId',
        populate: { path: 'userId', select: 'name phone profileImage' }
      })
      .sort('-appointmentDate');

    res.status(200).json({
      success: true,
      count: appointments.length,
      data: appointments
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching appointments',
      error: error.message
    });
  }
};

// @desc    Get appointments for a doctor
// @route   GET /api/appointments/doctor/:doctorId
// @access  Private (Doctor only)
exports.getDoctorAppointments = async (req, res) => {
  try {
    const appointments = await Appointment.find({ doctorId: req.params.doctorId })
      .populate({
        path: 'patientId',
        populate: { path: 'userId', select: 'name phone profileImage' }
      })
      .sort('-appointmentDate');

    res.status(200).json({
      success: true,
      count: appointments.length,
      data: appointments
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching appointments',
      error: error.message
    });
  }
};

// @desc    Update appointment status
// @route   PUT /api/appointments/:id
// @access  Private (Doctor or Patient)
exports.updateAppointment = async (req, res) => {
  try {
    const appointment = await Appointment.findById(req.params.id);

    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found'
      });
    }

    const updatedAppointment = await Appointment.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedAt: Date.now() },
      { new: true, runValidators: true }
    )
      .populate('patientId')
      .populate('doctorId');

    res.status(200).json({
      success: true,
      message: 'Appointment updated successfully',
      data: updatedAppointment
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating appointment',
      error: error.message
    });
  }
};

// @desc    Delete appointment
// @route   DELETE /api/appointments/:id
// @access  Private (Patient only)
exports.deleteAppointment = async (req, res) => {
  try {
    const appointment = await Appointment.findById(req.params.id);

    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found'
      });
    }

    await appointment.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Appointment cancelled successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error cancelling appointment',
      error: error.message
    });
  }
};
