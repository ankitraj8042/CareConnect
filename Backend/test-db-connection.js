// Quick test script to verify MongoDB connection
require('dotenv').config();
const mongoose = require('mongoose');

console.log('🔍 Testing MongoDB Connection...\n');
console.log('📍 Environment:', process.env.NODE_ENV);
console.log('📡 Connecting to MongoDB Atlas...\n');

mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => {
  console.log('✅ SUCCESS! MongoDB Connected Successfully!');
  console.log('📊 Database:', mongoose.connection.name);
  console.log('🌍 Host:', mongoose.connection.host);
  console.log('\n🎉 Your database is ready to use!');
  process.exit(0);
})
.catch((error) => {
  console.error('❌ ERROR: MongoDB Connection Failed');
  console.error('📝 Error Details:', error.message);
  console.log('\n🔧 Troubleshooting Tips:');
  console.log('   1. Check your MONGODB_URI in .env file');
  console.log('   2. Verify username and password are correct');
  console.log('   3. Make sure IP is whitelisted in MongoDB Atlas (Network Access)');
  console.log('   4. Check if <password> is replaced with actual password');
  console.log('   5. Ensure no spaces in connection string');
  process.exit(1);
});
