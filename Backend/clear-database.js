const mongoose = require('mongoose');
require('dotenv').config();

const User = require('./models/User.model');
const Doctor = require('./models/Doctor.model');
const Patient = require('./models/Patient.model');
const Pharmacy = require('./models/Pharmacy.model');
const Appointment = require('./models/Appointment.model');
const Prescription = require('./models/Prescription.model');

const clearDatabase = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    // Clear all collections
    await User.deleteMany({});
    console.log('✓ Cleared Users');

    await Doctor.deleteMany({});
    console.log('✓ Cleared Doctors');

    await Patient.deleteMany({});
    console.log('✓ Cleared Patients');

    await Pharmacy.deleteMany({});
    console.log('✓ Cleared Pharmacies');

    await Appointment.deleteMany({});
    console.log('✓ Cleared Appointments');

    await Prescription.deleteMany({});
    console.log('✓ Cleared Prescriptions');

    console.log('\n✅ Database cleared successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error clearing database:', error);
    process.exit(1);
  }
};

clearDatabase();
