const mongoose = require('mongoose');

const patientSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  dateOfBirth: {
    type: Date,
    required: true
  },
  gender: {
    type: String,
    enum: ['Male', 'Female', 'Other'],
    required: true
  },
  bloodGroup: {
    type: String,
    enum: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
  },
  address: {
    street: String,
    city: String,
    state: String,
    pincode: String,
    country: { type: String, default: 'India' }
  },
  emergencyContact: {
    name: String,
    relationship: String,
    phone: String
  },
  medicalHistory: [{
    condition: String,
    diagnosedDate: Date,
    notes: String,
    addedAt: { type: Date, default: Date.now }
  }],
  allergies: [{
    allergen: String,
    severity: { type: String, enum: ['Mild', 'Moderate', 'Severe'] },
    notes: String
  }],
  currentMedications: [{
    medicineName: String,
    dosage: String,
    frequency: String,
    startDate: Date,
    prescribedBy: String
  }],
  documents: [{
    title: String,
    description: String,
    fileUrl: String,
    uploadedAt: { type: Date, default: Date.now }
  }],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Patient', patientSchema);
