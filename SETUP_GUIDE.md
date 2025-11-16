# 🏥 CareConnect - Complete Setup Guide

## Overview
CareConnect is a Smart Healthcare Coordination Platform connecting patients, doctors, and pharmacists.

**Tech Stack:**
- Backend: Node.js + Express + MongoDB
- Frontend: Flutter (iOS/Android/Web)

---

## 📋 Prerequisites

Before starting, make sure you have:

### 1. Node.js & npm
Download from: https://nodejs.org/
```powershell
# Verify installation
node --version
npm --version
```

### 2. MongoDB Atlas Account
1. Go to https://www.mongodb.com/cloud/atlas
2. Sign up for free
3. Create a free cluster (M0)
4. Get connection string

### 3. Flutter SDK
Download from: https://flutter.dev/docs/get-started/install/windows
```powershell
# Verify installation
flutter --version
flutter doctor
```

### 4. Code Editor
- VS Code (Recommended) or
- Android Studio

---

## 🚀 Step-by-Step Setup

### PART 1: Backend Setup

#### 1. Navigate to Backend folder
```powershell
cd "c:\projects\GIT Avalanche\CareConnect\Backend"
```

#### 2. Install Dependencies
```powershell
npm install
```

This will install:
- express (Web framework)
- mongoose (MongoDB ORM)
- jsonwebtoken (Authentication)
- bcryptjs (Password hashing)
- cors (Cross-origin requests)
- dotenv (Environment variables)

#### 3. Configure Environment Variables
```powershell
# Copy the example file
copy .env.example .env
```

Edit `.env` file and add:
```env
PORT=5000
MONGODB_URI=mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@cluster.mongodb.net/careconnect?retryWrites=true&w=majority
JWT_SECRET=your_super_secret_key_minimum_32_characters_long
JWT_EXPIRE=7d
```

**Generate JWT Secret:**
```powershell
# Option 1: Use Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Option 2: Use any random string (32+ characters)
JWT_SECRET=my_super_secret_hackathon_key_2024_careconnect_app
```

**Get MongoDB URI:**
1. Login to MongoDB Atlas
2. Click "Connect" on your cluster
3. Choose "Connect your application"
4. Copy the connection string
5. Replace `<username>` and `<password>` with your credentials

#### 4. Start Backend Server
```powershell
# Development mode (auto-restart on changes)
npm run dev

# Production mode
npm start
```

✅ **Success!** Server should be running at http://localhost:5000

#### 5. Test Backend
Open browser or Postman:
```
GET http://localhost:5000/
```

Should return:
```json
{
  "message": "CareConnect API is running!",
  "version": "1.0.0",
  "status": "active"
}
```

---

### PART 2: Frontend Setup

#### 1. Navigate to Frontend folder
```powershell
cd "c:\projects\GIT Avalanche\CareConnect\Frontend"
```

#### 2. Install Flutter Dependencies
```powershell
flutter pub get
```

This will install all packages from `pubspec.yaml`

#### 3. Configure Backend URL

Edit `lib/config/api_constants.dart`:

```dart
// For local testing with backend on same machine
static const String baseUrl = 'http://localhost:5000/api';

// For Android Emulator (use 10.0.2.2 instead of localhost)
static const String baseUrl = 'http://10.0.2.2:5000/api';

// For deployed backend
static const String baseUrl = 'https://your-app.onrender.com/api';
```

#### 4. Run Flutter App

**Check available devices:**
```powershell
flutter devices
```

**Run on Chrome (Web):**
```powershell
flutter run -d chrome
```

**Run on Android Emulator:**
```powershell
flutter run -d emulator-5554
```

**Run on Connected Phone:**
```powershell
flutter run
```

✅ **Success!** App should launch with CareConnect splash screen

---

## 🧪 Testing the Application

### Test Flow 1: Patient Registration & Doctor Booking

1. **Register as Patient**
   - Open app → Click "Register"
   - Select "Patient" role
   - Fill details:
     - Name: John Doe
     - Email: john@test.com
     - Phone: 9876543210
     - Password: test123
     - DOB: 1990-01-01
     - Gender: Male
     - Blood Group: O+
   - Click "Register"

2. **Login**
   - Email: john@test.com
   - Password: test123
   - Click "Login"

3. **Expected**: Redirect to Patient Dashboard

### Test Flow 2: Doctor Registration

1. **Register as Doctor**
   - Select "Doctor" role
   - Fill details:
     - Name: Dr. Smith
     - Email: drsmith@test.com
     - Phone: 9876543211
     - Password: test123
     - Specialization: Cardiologist
     - License: DOC123456
     - Experience: 10 years
     - Fee: 500

2. **Login as Doctor**
   - View appointments dashboard

### Test Flow 3: Pharmacist Registration

1. **Register as Pharmacist**
   - Select "Pharmacist" role
   - Fill details:
     - Name: MedPlus Pharmacy
     - Email: medplus@test.com
     - Phone: 9876543212
     - Password: test123
     - Pharmacy Name: MedPlus
     - License: PHARM123456

2. **Login as Pharmacist**
   - Manage inventory dashboard

---

## 🐛 Common Issues & Solutions

### Issue 1: "npm not recognized"
**Solution:** Install Node.js from https://nodejs.org/

### Issue 2: "flutter not recognized"
**Solution:** 
1. Install Flutter SDK
2. Add to System PATH:
   - `C:\src\flutter\bin` (or your Flutter installation path)

### Issue 3: Backend - "MongooseServerSelectionError"
**Solution:**
1. Check MongoDB Atlas connection string
2. Whitelist your IP in MongoDB Atlas (Network Access)
3. Verify username/password

### Issue 4: Flutter - "Target of URI doesn't exist"
**Solution:**
```powershell
flutter clean
flutter pub get
```

### Issue 5: Android Emulator - "Connection refused"
**Solution:** Use `http://10.0.2.2:5000/api` instead of `localhost`

### Issue 6: CORS Error
**Solution:** Backend already has CORS enabled. If issue persists:
```javascript
// In server.js, update CORS:
app.use(cors({
  origin: '*', // For development only
  credentials: true
}));
```

---

## 📱 Building for Demo

### Web Build (Fastest for Hackathon Demo)
```powershell
cd Frontend
flutter build web
```

Output: `build/web` folder

**Deploy to:**
- Firebase Hosting (free)
- Netlify (free)
- GitHub Pages (free)

### Android APK
```powershell
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

Share APK for testing on any Android device!

---

## 🚀 Deployment (Free Options)

### Backend Deployment

#### Option 1: Render.com (Recommended)
1. Go to https://render.com
2. Sign up with GitHub
3. New → Web Service
4. Connect your GitHub repo
5. Configure:
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Environment Variables:** Add all from `.env`
6. Deploy!
7. Copy the URL (e.g., `https://careconnect-api.onrender.com`)
8. Update Flutter app's `api_constants.dart` with this URL

#### Option 2: Railway.app
1. Go to https://railway.app
2. Deploy from GitHub
3. Add environment variables
4. Get deployment URL

### Frontend Deployment (Web)

#### Firebase Hosting
```powershell
npm install -g firebase-tools
firebase login
firebase init hosting
# Select build/web as public directory
firebase deploy
```

#### Netlify
1. Go to https://netlify.com
2. Drag & drop `build/web` folder
3. Done!

---

## 📊 Project Structure

```
CareConnect/
├── Backend/
│   ├── config/          # Database configuration
│   ├── controllers/     # Business logic
│   ├── middleware/      # Auth, validation
│   ├── models/          # MongoDB schemas
│   ├── routes/          # API endpoints
│   ├── .env            # Environment variables (not in git)
│   ├── .env.example    # Template for .env
│   ├── package.json    # Dependencies
│   └── server.js       # Entry point
│
└── Frontend/
    ├── lib/
    │   ├── config/      # API constants
    │   ├── models/      # Data models
    │   ├── providers/   # State management
    │   ├── screens/     # UI screens
    │   ├── services/    # API calls
    │   └── main.dart    # Entry point
    ├── pubspec.yaml    # Flutter dependencies
    └── README.md       # Frontend docs
```

---

## 🎯 Hackathon Demo Script

### 1. Introduction (1 min)
"CareConnect is a unified healthcare platform connecting patients, doctors, and pharmacists"

### 2. Patient Journey (2 min)
- Register as patient
- Search for doctors by specialization
- Book appointment
- Search for medicines

### 3. Doctor Journey (1 min)
- Login as doctor
- View appointments
- Access patient history
- Create prescription

### 4. Pharmacist Journey (1 min)
- Login as pharmacist
- Manage inventory
- Update stock levels

### 5. Key Features Highlight (1 min)
- Role-based access
- Real-time availability
- Medicine search
- Secure data handling

---

## 📝 API Testing with Postman

### Register Patient
```
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@test.com",
  "password": "test123",
  "phone": "9876543210",
  "role": "patient",
  "dateOfBirth": "1990-01-01",
  "gender": "Male",
  "bloodGroup": "O+"
}
```

### Login
```
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "john@test.com",
  "password": "test123"
}
```

Copy the `token` from response!

### Get All Doctors
```
GET http://localhost:5000/api/doctors
```

### Book Appointment
```
POST http://localhost:5000/api/appointments
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: application/json

{
  "patientId": "PATIENT_ID",
  "doctorId": "DOCTOR_ID",
  "appointmentDate": "2024-03-25",
  "timeSlot": {
    "startTime": "10:00",
    "endTime": "10:30"
  },
  "chiefComplaint": "Chest pain"
}
```

---

## 🏆 Tips for Hackathon Success

1. **Focus on Demo Flow**
   - Have pre-registered accounts ready
   - Test the complete user journey before demo

2. **Error Handling**
   - Add loading states
   - Show clear error messages

3. **Visual Polish**
   - Use consistent colors (already done!)
   - Add icons for better UX

4. **Backup Plan**
   - Record a demo video
   - Keep screenshots ready

5. **Future Roadmap Slide**
   - AI Medical Scribe (voice-to-text)
   - Telemedicine (video calls)
   - Emergency QR access
   - Payment integration
   - Analytics dashboard

---

## 📞 Need Help?

Check these resources:
- **Flutter Docs:** https://flutter.dev/docs
- **Express.js:** https://expressjs.com/
- **MongoDB:** https://docs.mongodb.com/
- **Stack Overflow:** For specific errors

---

## ✅ Final Checklist Before Demo

- [ ] Backend running on local/deployed server
- [ ] Frontend connected to backend
- [ ] Test patient registration
- [ ] Test doctor registration
- [ ] Test pharmacist registration
- [ ] Test appointment booking
- [ ] Test medicine search
- [ ] Take screenshots
- [ ] Record backup demo video
- [ ] Prepare presentation slides

---

**Good luck with your hackathon! 🚀**

For questions or issues, review the error messages carefully - they usually point to the solution!
