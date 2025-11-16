# ✅ CareConnect - Quick Start Checklist

Use this checklist to set up your project step by step!

## 📋 Initial Setup

### Prerequisites Installation
- [ ] Install Node.js (v18+) from https://nodejs.org/
  - Verify: `node --version`
  - Verify: `npm --version`
  
- [ ] Install Flutter SDK from https://flutter.dev/
  - Verify: `flutter --version`
  - Run: `flutter doctor`
  
- [ ] Create MongoDB Atlas account at https://www.mongodb.com/cloud/atlas
  - Create free M0 cluster
  - Note down connection string

- [ ] Install VS Code or Android Studio
  - Install Flutter extension (VS Code)

---

## 🔧 Backend Setup

### Step 1: Install Dependencies
- [ ] Open terminal in Backend folder
- [ ] Run: `npm install`
- [ ] Wait for all packages to install (~2 minutes)

### Step 2: Configure Environment
- [ ] Copy `.env.example` to `.env`
- [ ] Open `.env` file
- [ ] Update `MONGODB_URI` with your MongoDB Atlas connection string
- [ ] Generate JWT secret (32+ characters)
  ```bash
  node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
  ```
- [ ] Update `JWT_SECRET` in `.env`

### Step 3: Start Backend Server
- [ ] Run: `npm run dev` (development mode)
- [ ] Verify: Server running on http://localhost:5000
- [ ] Test: Open http://localhost:5000 in browser
- [ ] Expected: JSON response with "CareConnect API is running!"

### Step 4: Test API (Optional)
- [ ] Install Postman or Thunder Client (VS Code extension)
- [ ] Test health endpoint: `GET http://localhost:5000/`
- [ ] Keep server running for next steps

---

## 📱 Frontend Setup

### Step 1: Install Dependencies
- [ ] Open new terminal in Frontend folder
- [ ] Run: `flutter pub get`
- [ ] Wait for packages to download

### Step 2: Configure Backend URL
- [ ] Open `lib/config/api_constants.dart`
- [ ] Check `baseUrl`:
  - For web: `http://localhost:5000/api`
  - For Android emulator: `http://10.0.2.2:5000/api`
  - For deployed: `https://your-app.onrender.com/api`

### Step 3: Run Flutter App
- [ ] Check available devices: `flutter devices`
- [ ] Choose a device:
  - Web: `flutter run -d chrome`
  - Android: `flutter run -d emulator-XXXX`
  - Connected phone: `flutter run`

### Step 4: Verify App Launch
- [ ] App opens with CareConnect splash screen
- [ ] Redirects to login screen
- [ ] UI loads correctly without errors

---

## 🧪 Testing Application

### Test 1: Patient Registration
- [ ] Click "Register" button
- [ ] Select "Patient" role
- [ ] Fill form:
  - Name: Test Patient
  - Email: patient@test.com
  - Phone: 9876543210
  - Password: test123
  - DOB: 1990-01-01
  - Gender: Male
  - Blood Group: O+
- [ ] Click "Register"
- [ ] Success message appears
- [ ] Redirects to login

### Test 2: Patient Login
- [ ] Enter email: patient@test.com
- [ ] Enter password: test123
- [ ] Click "Login"
- [ ] Redirects to Patient Dashboard
- [ ] Dashboard shows welcome message

### Test 3: Doctor Registration
- [ ] Logout from patient account
- [ ] Register as Doctor:
  - Name: Dr. Smith
  - Email: doctor@test.com
  - Phone: 9876543211
  - Password: test123
  - Specialization: Cardiologist
  - License: DOC123456
  - Experience: 10
  - Fee: 500
- [ ] Login as doctor
- [ ] Doctor dashboard appears

### Test 4: Pharmacist Registration
- [ ] Register as Pharmacist:
  - Name: MedPlus Pharmacy
  - Email: pharmacy@test.com
  - Phone: 9876543212
  - Password: test123
  - Pharmacy Name: MedPlus
  - License: PHARM123456
- [ ] Login as pharmacist
- [ ] Pharmacist dashboard appears

---

## 🔍 Troubleshooting

### Backend Issues
- [ ] MongoDB connection error?
  - Check connection string format
  - Whitelist IP in MongoDB Atlas (Network Access → Add IP → Allow from anywhere)
  - Verify username/password

- [ ] Port 5000 already in use?
  - Change `PORT=5001` in `.env`
  - Restart server

- [ ] JWT errors?
  - Ensure JWT_SECRET is set in `.env`
  - Regenerate if needed

### Frontend Issues
- [ ] Package errors?
  ```bash
  flutter clean
  flutter pub get
  ```

- [ ] Build errors?
  ```bash
  flutter pub upgrade
  ```

- [ ] Network connection errors?
  - Verify backend is running
  - Check API URL in `api_constants.dart`
  - Use `10.0.2.2` for Android emulator

- [ ] Hot reload not working?
  - Press 'R' in terminal for full restart
  - Restart the app

---

## 📦 Building for Demo

### Android APK (Recommended for Hackathon)
- [ ] Run: `flutter build apk --release`
- [ ] Find APK: `build/app/outputs/flutter-apk/app-release.apk`
- [ ] Test APK on physical device
- [ ] Share APK link

### Web Build
- [ ] Run: `flutter build web`
- [ ] Output in: `build/web`
- [ ] Deploy to Firebase/Netlify

---

## 🚀 Deployment Checklist

### Backend Deployment (Render.com)
- [ ] Sign up at https://render.com
- [ ] Create new Web Service
- [ ] Connect GitHub repository
- [ ] Set environment variables from `.env`
- [ ] Deploy
- [ ] Copy deployment URL
- [ ] Test: `https://your-app.onrender.com/`

### Frontend Configuration
- [ ] Update `api_constants.dart` with deployed backend URL
- [ ] Rebuild app: `flutter build apk --release`
- [ ] Test with deployed backend

### MongoDB Atlas
- [ ] Whitelist all IPs (0.0.0.0/0) for demo
- [ ] Or add Render.com IP addresses

---

## 📹 Demo Preparation

### Before Demo
- [ ] Test all registration flows
- [ ] Pre-register test accounts
- [ ] Clear app cache for fresh demo
- [ ] Charge laptop/phone
- [ ] Test internet connection
- [ ] Backup: Record demo video

### Demo Flow
- [ ] Start with problem statement
- [ ] Show registration (patient)
- [ ] Show doctor dashboard
- [ ] Show pharmacy features
- [ ] Highlight security features
- [ ] Mention future roadmap

### Demo Accounts (Prepare These)
- [ ] Patient: patient@demo.com / demo123
- [ ] Doctor: doctor@demo.com / demo123
- [ ] Pharmacist: pharmacy@demo.com / demo123

---

## 📊 Final Verification

### Functionality Check
- [ ] Registration works for all roles
- [ ] Login works for all roles
- [ ] Logout works correctly
- [ ] Role-based dashboards load
- [ ] No console errors
- [ ] Loading states work
- [ ] Error messages display

### Code Quality
- [ ] No compilation errors
- [ ] No runtime errors
- [ ] Clean console logs
- [ ] API responses are correct
- [ ] JWT authentication works

### Documentation
- [ ] README.md is complete
- [ ] SETUP_GUIDE.md is clear
- [ ] API endpoints documented
- [ ] Screenshots prepared

---

## 🎯 Pre-Submission Checklist

- [ ] Code pushed to GitHub
- [ ] Backend deployed and accessible
- [ ] Frontend built (APK/Web)
- [ ] Demo video recorded (backup)
- [ ] Presentation slides prepared
- [ ] Team members briefed
- [ ] All features tested
- [ ] Known issues documented

---

## 📈 Post-Hackathon (Optional)

- [ ] Add AI medical scribe
- [ ] Implement video consultation
- [ ] Add payment gateway
- [ ] Implement push notifications
- [ ] Add analytics dashboard
- [ ] Improve UI/UX
- [ ] Add unit tests
- [ ] Performance optimization

---

## ✨ Success Criteria

You're ready when:
- ✅ Backend server runs without errors
- ✅ Flutter app builds successfully
- ✅ All 3 roles can register/login
- ✅ Dashboards load correctly
- ✅ No critical bugs
- ✅ Demo flow is smooth

---

## 🎉 You're All Set!

If all checkboxes above are checked, you're ready to demo CareConnect!

**Good luck with your hackathon! 🚀**

---

## 🆘 Need Help?

1. Check `SETUP_GUIDE.md` for detailed instructions
2. Review error messages carefully
3. Check Backend/Frontend README files
4. Google specific error messages
5. Check Stack Overflow

---

**Time to shine! 🌟**
