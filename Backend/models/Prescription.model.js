const mongoose = require('mongoose');

const prescriptionSchema = new mongoose.Schema({
  appointmentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Appointment',
    required: true
  },
  patientId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Patient',
    required: true
  },
  doctorId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Doctor',
    required: true
  },
  diagnosis: {
    type: String,
    required: true
  },
  symptoms: [{
    type: String
  }],
  medicines: [{
    medicineName: { type: String, required: true },
    genericName: String,
    dosage: { type: String, required: true }, // e.g., "500mg"
    frequency: { type: String, required: true }, // e.g., "2 times daily"
    duration: { type: String, required: true }, // e.g., "7 days"
    instructions: String, // e.g., "Take after meals"
    quantity: { type: Number, required: true }
  }],
  vitalSigns: {
    bloodPressure: String, // "120/80"
    temperature: Number,   // 98.6
    pulse: Number,         // 72
    weight: Number,        // in kg
    height: Number         // in cm
  },
  labTests: [{
    testName: String,
    reason: String
  }],
  doctorNotes: {
    type: String,
    maxlength: 2000
  },
  followUpDate: {
    type: Date
  },
  issuedDate: {
    type: Date,
    default: Date.now
  },
  validUntil: {
    type: Date,
    default: function() {
      // Valid for 30 days by default
      const date = new Date();
      date.setDate(date.getDate() + 30);
      return date;
    }
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Prescription', prescriptionSchema);
