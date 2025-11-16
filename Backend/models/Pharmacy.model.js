const mongoose = require('mongoose');

const pharmacySchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  pharmacyName: {
    type: String,
    required: [true, 'Pharmacy name is required'],
    trim: true
  },
  licenseNumber: {
    type: String,
    required: [true, 'License number is required'],
    unique: true
  },
  licenseDocument: {
    type: String,
    default: ''
  },
  address: {
    street: { type: String, required: true },
    city: { type: String, required: true },
    state: { type: String, required: true },
    pincode: { type: String, required: true },
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
  workingHours: {
    openTime: { type: String, default: '09:00' },
    closeTime: { type: String, default: '21:00' },
    workingDays: [{
      type: String,
      enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    }]
  },
  inventory: [{
    medicineName: { type: String, required: true },
    genericName: String,
    manufacturer: String,
    category: {
      type: String,
      enum: ['Tablet', 'Capsule', 'Syrup', 'Injection', 'Drops', 'Ointment', 'Cream', 'Other']
    },
    price: { type: Number, required: true },
    stock: { type: Number, required: true, default: 0 },
    expiryDate: { type: Date, required: true },
    batchNumber: String,
    requiresPrescription: { type: Boolean, default: true },
    addedAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
  }],
  rating: {
    average: { type: Number, default: 0 },
    count: { type: Number, default: 0 }
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Index for geospatial queries
pharmacySchema.index({ location: '2dsphere' });
pharmacySchema.index({ 'inventory.medicineName': 'text' });

module.exports = mongoose.model('Pharmacy', pharmacySchema);
