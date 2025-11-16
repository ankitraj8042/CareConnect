require('dotenv').config();
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const User = require('./models/User.model');
const Doctor = require('./models/Doctor.model');
const Patient = require('./models/Patient.model');
const Pharmacy = require('./models/Pharmacy.model');
const Appointment = require('./models/Appointment.model');
const Prescription = require('./models/Prescription.model');

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('✅ MongoDB Connected for seeding'))
.catch((err) => console.error('❌ MongoDB connection error:', err));

async function seedDatabase() {
  try {
    console.log('🌱 Starting database seeding...\n');

    // Clear existing data (optional - comment out if you want to keep existing data)
    // await User.deleteMany({});
    // await Doctor.deleteMany({});
    // await Patient.deleteMany({});
    // await Pharmacy.deleteMany({});
    // await Appointment.deleteMany({});
    // await Prescription.deleteMany({});
    // console.log('🗑️  Cleared existing data\n');

    // Create demo doctors
    console.log('👨‍⚕️  Creating doctors...');
    const doctorUsers = [];
    const doctors = [];

    const doctorData = [
      {
        name: 'Dr. Sarah Johnson',
        email: 'sarah.johnson@hospital.com',
        phone: '+1234567890',
        specialization: 'Cardiologist',
        experience: 15,
        qualifications: [
          { degree: 'MBBS', institution: 'Harvard Medical School', year: 2005 },
          { degree: 'MD Cardiology', institution: 'Johns Hopkins', year: 2008 },
          { degree: 'FACC', institution: 'American College of Cardiology', year: 2010 }
        ],
        consultationFee: 500,
        address: {
          street: '123 Medical Plaza',
          city: 'New York',
          state: 'NY',
          pincode: '10001'
        }
      },
      {
        name: 'Dr. Michael Chen',
        email: 'michael.chen@hospital.com',
        phone: '+1234567891',
        specialization: 'Pediatrician',
        experience: 10,
        qualifications: [
          { degree: 'MBBS', institution: 'Stanford University', year: 2010 },
          { degree: 'MD Pediatrics', institution: 'UCLA', year: 2013 }
        ],
        consultationFee: 400,
        address: {
          street: '456 Health Center',
          city: 'Los Angeles',
          state: 'CA',
          pincode: '90001'
        }
      },
      {
        name: 'Dr. Emily Williams',
        email: 'emily.williams@hospital.com',
        phone: '+1234567892',
        specialization: 'Dermatologist',
        experience: 8,
        qualifications: [
          { degree: 'MBBS', institution: 'Columbia University', year: 2012 },
          { degree: 'MD Dermatology', institution: 'NYU', year: 2015 }
        ],
        consultationFee: 450,
        address: {
          street: '789 Skin Care Clinic',
          city: 'Chicago',
          state: 'IL',
          pincode: '60601'
        }
      },
      {
        name: 'Dr. James Brown',
        email: 'james.brown@hospital.com',
        phone: '+1234567893',
        specialization: 'Orthopedic',
        experience: 12,
        qualifications: [
          { degree: 'MBBS', institution: 'Yale University', year: 2008 },
          { degree: 'MS Orthopedics', institution: 'Mayo Clinic', year: 2011 }
        ],
        consultationFee: 550,
        address: {
          street: '321 Bone & Joint Center',
          city: 'Houston',
          state: 'TX',
          pincode: '77001'
        }
      }
    ];

    for (const doc of doctorData) {
      const hashedPassword = await bcrypt.hash('doctor123', 10);
      const user = await User.create({
        name: doc.name,
        email: doc.email,
        phone: doc.phone,
        password: hashedPassword,
        role: 'doctor',
        isVerified: true
      });
      doctorUsers.push(user);

      const doctor = await Doctor.create({
        userId: user._id,
        specialization: doc.specialization,
        licenseNumber: `LIC${Math.floor(Math.random() * 100000)}`,
        experience: doc.experience,
        qualifications: doc.qualifications,
        consultationFee: doc.consultationFee,
        address: doc.address,
        availableTimeSlots: [
          { day: 'Monday', startTime: '09:00', endTime: '17:00' },
          { day: 'Tuesday', startTime: '09:00', endTime: '17:00' },
          { day: 'Wednesday', startTime: '09:00', endTime: '17:00' },
          { day: 'Thursday', startTime: '09:00', endTime: '17:00' },
          { day: 'Friday', startTime: '09:00', endTime: '17:00' }
        ],
        rating: {
          average: 4.5 + Math.random() * 0.5,
          count: Math.floor(Math.random() * 100) + 20
        }
      });
      doctors.push(doctor);
      console.log(`  ✓ Created ${doc.name}`);
    }

    // Create demo pharmacies
    console.log('\n💊 Creating pharmacies...');
    const pharmacyUsers = [];
    const pharmacies = [];

    const pharmacyData = [
      {
        name: 'HealthPlus Pharmacy',
        email: 'contact@healthplus.com',
        phone: '+1234567894',
        pharmacyName: 'HealthPlus Pharmacy',
        address: {
          street: '100 Main Street',
          city: 'New York',
          state: 'NY',
          pincode: '10002'
        }
      },
      {
        name: 'MediCare Drugstore',
        email: 'info@medicare.com',
        phone: '+1234567895',
        pharmacyName: 'MediCare Drugstore',
        address: {
          street: '200 Oak Avenue',
          city: 'Los Angeles',
          state: 'CA',
          pincode: '90002'
        }
      },
      {
        name: 'WellLife Pharmacy',
        email: 'support@welllife.com',
        phone: '+1234567896',
        pharmacyName: 'WellLife Pharmacy',
        address: {
          street: '300 Pine Road',
          city: 'Chicago',
          state: 'IL',
          pincode: '60602'
        }
      }
    ];

    const commonMedicines = [
      { name: 'Aspirin', type: 'Tablet', price: 5.99, stock: 500 },
      { name: 'Paracetamol', type: 'Tablet', price: 3.99, stock: 600 },
      { name: 'Ibuprofen', type: 'Tablet', price: 7.99, stock: 400 },
      { name: 'Amoxicillin', type: 'Capsule', price: 12.99, stock: 300 },
      { name: 'Omeprazole', type: 'Capsule', price: 15.99, stock: 250 },
      { name: 'Vitamin D3', type: 'Tablet', price: 8.99, stock: 350 },
      { name: 'Multivitamin', type: 'Tablet', price: 11.99, stock: 400 },
      { name: 'Cough Syrup', type: 'Syrup', price: 6.99, stock: 200 }
    ];

    for (const pharm of pharmacyData) {
      const hashedPassword = await bcrypt.hash('pharmacy123', 10);
      const user = await User.create({
        name: pharm.name,
        email: pharm.email,
        phone: pharm.phone,
        password: hashedPassword,
        role: 'pharmacist',
        isVerified: true
      });
      pharmacyUsers.push(user);

      const pharmacy = await Pharmacy.create({
        userId: user._id,
        pharmacyName: pharm.pharmacyName,
        licenseNumber: `PHARM${Math.floor(Math.random() * 100000)}`,
        address: pharm.address,
        medicines: commonMedicines,
        operatingHours: {
          open: '08:00',
          close: '22:00'
        },
        rating: {
          average: 4.0 + Math.random() * 1.0,
          count: Math.floor(Math.random() * 50) + 10
        }
      });
      pharmacies.push(pharmacy);
      console.log(`  ✓ Created ${pharm.pharmacyName}`);
    }

    console.log('\n✅ Demo data seeded successfully!');
    console.log('\n📝 Login Credentials:');
    console.log('\nDoctors:');
    doctorData.forEach((doc, i) => {
      console.log(`  Email: ${doc.email}`);
      console.log(`  Password: doctor123\n`);
    });
    console.log('\nPharmacies:');
    pharmacyData.forEach((pharm, i) => {
      console.log(`  Email: ${pharm.email}`);
      console.log(`  Password: pharmacy123\n`);
    });

    console.log('Note: Create patient accounts through the registration screen.');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  }
}

seedDatabase();
