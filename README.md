# 🏥 CareConnect - Smart Healthcare Coordination Platform

> **Complete end-to-end healthcare platform connecting patients, doctors, and pharmacists**

[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-brightgreen.svg)](https://www.mongodb.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📖 Table of Contents
- [Problem Statement](#-problem-statement)
- [Solution](#-solution)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [API Documentation](#-api-documentation)
- [Screenshots](#-screenshots)
- [Deployment](#-deployment)
- [Future Roadmap](#-future-roadmap)
- [Contributing](#-contributing)

---

## 🎯 Problem Statement

Most healthcare ecosystems suffer from:
- **Fragmentation** - No unified platform for all stakeholders
- **Access Issues** - Difficulty finding verified doctors and available appointments
- **Fragmented Records** - Medical history not accessible during emergencies
- **Medicine Unavailability** - Hard to locate pharmacies with required medicines in stock
- **Administrative Burden** - Manual documentation and prescription processes
- **Inventory Mismanagement** - Expired medicines and stock issues at pharmacies

---

## 💡 Solution

**CareConnect** is a unified digital platform that:
1. ✅ Connects **patients, doctors, and pharmacists** in one ecosystem
2. ✅ Enables **real-time service availability** and appointment booking
3. ✅ Maintains **secure digital medical records**
4. ✅ Provides **medicine search across pharmacies**
5. ✅ Simplifies **prescription management**
6. ✅ Streamlines **pharmacy inventory tracking**

---

## 🚀 Features

### 👨‍⚕️ For Patients
- 🔍 Search doctors by specialization and location
- 📅 Book appointments with real-time availability
- 📋 Maintain digital medical history
- 💊 Search medicine availability across pharmacies
- 📄 Access prescriptions and medical documents

### 🩺 For Doctors
- 📊 Manage appointment schedule
- 👥 Access patient medical history
- ✍️ Create digital prescriptions
- 📈 Track patient consultations
- ⏰ Update availability slots

### 💊 For Pharmacists
- 📦 Manage medicine inventory
- ⚠️ Track expiring medicines
- 🔄 Update stock levels
- 📍 Location-based visibility
- 💰 Manage pricing

---

## 🛠️ Tech Stack

### Backend
```
Node.js (v18+)
├── Express.js          - Web framework
├── MongoDB Atlas       - Database (free tier)
├── Mongoose            - ODM
├── JWT                 - Authentication
├── bcryptjs            - Password hashing
└── CORS                - Cross-origin support
```

### Frontend
```
Flutter (3.0+)
├── Provider            - State management
├── HTTP                - API calls
├── SharedPreferences   - Local storage
├── Material Design     - UI components
└── Intl                - Date formatting
```

### Infrastructure
```
Deployment Options (All Free):
├── Backend: Render.com / Railway.app
├── Database: MongoDB Atlas (M0 - 512MB)
├── Frontend Web: Firebase / Netlify
└── Android: APK distribution
```

---

## 📁 Project Structure

```
CareConnect/
│
├── Backend/                        # Node.js + Express API
│   ├── config/
│   │   └── db.js                  # MongoDB connection
│   ├── controllers/               # Business logic
│   │   ├── auth.controller.js     # Registration, login
│   │   ├── doctor.controller.js   # Doctor CRUD
│   │   ├── patient.controller.js  # Patient management
│   │   ├── appointment.controller.js
│   │   ├── prescription.controller.js
│   │   └── pharmacy.controller.js
│   ├── middleware/
│   │   └── auth.middleware.js     # JWT verification
│   ├── models/                    # MongoDB schemas
│   │   ├── User.model.js
│   │   ├── Doctor.model.js
│   │   ├── Patient.model.js
│   │   ├── Pharmacy.model.js
│   │   ├── Appointment.model.js
│   │   └── Prescription.model.js
│   ├── routes/                    # API endpoints
│   │   ├── auth.routes.js         # POST /api/auth/login
│   │   ├── doctor.routes.js       # GET /api/doctors
│   │   ├── patient.routes.js
│   │   ├── appointment.routes.js
│   │   ├── prescription.routes.js
│   │   └── pharmacy.routes.js
│   ├── .env.example               # Environment template
│   ├── .gitignore
│   ├── package.json
│   ├── server.js                  # Entry point
│   └── README.md
│
├── Frontend/                      # Flutter Mobile App
│   ├── lib/
│   │   ├── config/
│   │   │   └── api_constants.dart # API endpoints
│   │   ├── models/                # Data models
│   │   │   ├── user_model.dart
│   │   │   ├── doctor_model.dart
│   │   │   ├── appointment_model.dart
│   │   │   └── pharmacy_model.dart
│   │   ├── providers/             # State management
│   │   │   ├── auth_provider.dart
│   │   │   ├── doctor_provider.dart
│   │   │   ├── appointment_provider.dart
│   │   │   └── pharmacy_provider.dart
│   │   ├── screens/               # UI screens
│   │   │   ├── splash_screen.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── patient/
│   │   │   │   └── patient_dashboard.dart
│   │   │   ├── doctor/
│   │   │   │   └── doctor_dashboard.dart
│   │   │   └── pharmacist/
│   │   │       └── pharmacist_dashboard.dart
│   │   ├── services/
│   │   │   └── api_service.dart   # HTTP client
│   │   └── main.dart              # App entry
│   ├── pubspec.yaml               # Dependencies
│   └── README.md
│
├── SETUP_GUIDE.md                 # Complete setup instructions
└── README.md                      # This file
```

---

## 🏃 Getting Started

### Prerequisites
1. **Node.js** (v18+) - [Download](https://nodejs.org/)
2. **Flutter SDK** (3.0+) - [Download](https://flutter.dev/)
3. **MongoDB Atlas** account - [Free Signup](https://www.mongodb.com/cloud/atlas)
4. **VS Code** or **Android Studio**

### Quick Start (5 Minutes)

#### 1. Clone Repository
```bash
cd "c:\projects\GIT Avalanche\CareConnect"
```

#### 2. Setup Backend
```bash
cd Backend
npm install
copy .env.example .env
# Edit .env with your MongoDB URI
npm run dev
```

#### 3. Setup Frontend
```bash
cd Frontend
flutter pub get
flutter run -d chrome
```

**📝 For detailed instructions, see [SETUP_GUIDE.md](./SETUP_GUIDE.md)**

---

## 📡 API Documentation

### Base URL
```
http://localhost:5000/api
```

### Authentication Endpoints

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "9876543210",
  "role": "patient",
  "dateOfBirth": "1990-01-01",
  "gender": "Male",
  "bloodGroup": "O+"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}

Response:
{
  "success": true,
  "data": {
    "user": { ... },
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "roleProfileId": "..."
  }
}
```

### Doctor Endpoints

```http
GET    /api/doctors                          # Get all doctors
GET    /api/doctors/:id                      # Get doctor by ID
GET    /api/doctors/:id/availability        # Get availability
PUT    /api/doctors/:id                      # Update profile (Auth)
GET    /api/doctors/specializations/list    # Get specializations
```

### Appointment Endpoints

```http
POST   /api/appointments                     # Book appointment (Auth)
GET    /api/appointments/patient/:patientId # Get patient appointments (Auth)
GET    /api/appointments/doctor/:doctorId   # Get doctor appointments (Auth)
PUT    /api/appointments/:id                 # Update appointment (Auth)
DELETE /api/appointments/:id                 # Cancel appointment (Auth)
```

### Pharmacy Endpoints

```http
GET    /api/pharmacies                       # Get all pharmacies
GET    /api/pharmacies/:id                   # Get pharmacy by ID
GET    /api/pharmacies/search/medicine       # Search medicine
POST   /api/pharmacies/:id/inventory         # Add medicine (Auth)
PUT    /api/pharmacies/:id/inventory/:medId  # Update medicine (Auth)
DELETE /api/pharmacies/:id/inventory/:medId  # Delete medicine (Auth)
```

### Authentication Header
```http
Authorization: Bearer <your_jwt_token>
```

---

## 📸 Screenshots

### Patient Dashboard
- Search doctors by specialization
- Book appointments
- View medical history
- Search medicines

### Doctor Dashboard
- View appointments
- Access patient records
- Create prescriptions
- Manage availability

### Pharmacist Dashboard
- Manage inventory
- Track expiring medicines
- Update stock levels

---

## 🚀 Deployment

### Backend (Render.com - Free)

1. Create account at [render.com](https://render.com)
2. New → Web Service
3. Connect GitHub repository
4. Configure:
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Environment Variables:** Copy from `.env`
5. Deploy!

### Frontend (Firebase - Free)

```bash
cd Frontend
flutter build web
npm install -g firebase-tools
firebase login
firebase init hosting
firebase deploy
```

### Alternative Deployments

**Backend:**
- Railway.app
- Cyclic.sh
- Heroku (free tier)

**Frontend:**
- Netlify
- Vercel
- GitHub Pages

---

## 🔮 Future Roadmap

### Phase 1 (MVP) ✅
- [x] User authentication
- [x] Doctor search & booking
- [x] Medicine search
- [x] Basic dashboards

### Phase 2 (Coming Soon)
- [ ] AI Medical Scribe (voice-to-text)
- [ ] Video consultation (telemedicine)
- [ ] Payment integration
- [ ] Push notifications

### Phase 3 (Advanced)
- [ ] Emergency QR code access
- [ ] Analytics dashboard
- [ ] Multi-language support
- [ ] Blockchain for medical records

---

## 🤝 Contributing

We welcome contributions! Here's how:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

## 👥 Team

Built for hackathon by passionate developers solving real healthcare problems.

---

## 🙏 Acknowledgments

- MongoDB Atlas for free database hosting
- Render.com for backend deployment
- Flutter community for amazing packages
- All healthcare workers who inspired this project

---

## 📞 Support

Have questions? Issues?

1. Check [SETUP_GUIDE.md](./SETUP_GUIDE.md)
2. Open an issue on GitHub
3. Check existing issues for solutions

---

## 🎯 Hackathon Demo Tips

1. **Preparation**
   - Pre-register test accounts
   - Prepare demo script
   - Test all flows

2. **Presentation**
   - Start with problem statement
   - Show patient journey
   - Demonstrate doctor workflow
   - Highlight pharmacy features

3. **Key Points to Emphasize**
   - Unified platform (3 roles)
   - Real-time availability
   - Security (JWT, encryption)
   - Scalability (cloud-based)
   - Free to deploy

---

## 📊 Statistics

- **Lines of Code:** ~5,000+
- **API Endpoints:** 20+
- **Database Models:** 6
- **UI Screens:** 10+
- **Development Time:** Hackathon-ready ⚡

---

**Made with ❤️ for better healthcare access**

```
  ╔══════════════════════════════════╗
  ║     CareConnect Platform        ║
  ║  Connecting Healthcare Together  ║
  ╚══════════════════════════════════╝
```

---

## 🚀 Quick Commands Reference

```bash
# Backend
cd Backend
npm install
npm run dev

# Frontend
cd Frontend
flutter pub get
flutter run -d chrome

# Build for production
flutter build apk --release
flutter build web
```

---

**Ready to revolutionize healthcare! 🏥**
