const mongoose = require('mongoose');

const doctorSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  specialization: {
    type: String,
    required: [true, 'Specialization is required'],
    enum: [
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
    ]
  },
  qualifications: [{
    degree: String,
    institution: String,
    year: Number
  }],
  licenseNumber: {
    type: String,
    required: [true, 'License number is required'],
    unique: true
  },
  licenseDocument: {
    type: String, // URL to uploaded document
    default: ''
  },
  experience: {
    type: Number,
    required: true,
    min: 0
  },
  consultationFee: {
    type: Number,
    required: true,
    min: 0
  },
  address: {
    street: String,
    city: String,
    state: String,
    pincode: String,
    country: { type: String, default: 'India' }
  },
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      default: [0, 0]
    }
  },
  availability: [{
    day: {
      type: String,
      enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    },
    slots: [{
      startTime: String, // "09:00"
      endTime: String,   // "10:00"
      isBooked: { type: Boolean, default: false }
    }]
  }],
  rating: {
    average: { type: Number, default: 0 },
    count: { type: Number, default: 0 }
  },
  bio: {
    type: String,
    maxlength: 500
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Index for geospatial queries
doctorSchema.index({ location: '2dsphere' });

module.exports = mongoose.model('Doctor', doctorSchema);
