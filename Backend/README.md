# CareConnect Backend API

Backend server for CareConnect - Smart Healthcare Coordination Platform

## 🚀 Quick Start

### Prerequisites
- Node.js (v16 or higher)
- MongoDB Atlas account (free tier)
- npm or yarn

### Installation

1. **Install dependencies**
```bash
cd Backend
npm install
```

2. **Environment Setup**
```bash
# Copy the example env file
copy .env.example .env

# Edit .env and add your MongoDB URI and JWT secret
```

3. **MongoDB Atlas Setup**
- Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
- Create a free cluster
- Get your connection string
- Replace `<username>` and `<password>` in `.env`

4. **Generate JWT Secret**
```bash
# Run this in Node.js or use any random string generator
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

5. **Start the server**
```bash
# Development mode
npm run dev

# Production mode
npm start
```

Server will run on `http://localhost:5000`

## 📚 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user (Protected)

### Doctors
- `GET /api/doctors` - Get all doctors (with filters)
- `GET /api/doctors/:id` - Get doctor by ID
- `GET /api/doctors/:id/availability` - Get doctor availability
- `PUT /api/doctors/:id` - Update doctor profile (Protected)
- `GET /api/doctors/specializations/list` - Get specializations

### Patients
- `GET /api/patients/:id` - Get patient profile (Protected)
- `PUT /api/patients/:id` - Update patient profile (Protected)
- `POST /api/patients/:id/medical-history` - Add medical history (Protected)
- `POST /api/patients/:id/documents` - Add document (Protected)

### Appointments
- `POST /api/appointments` - Create appointment (Protected - Patient)
- `GET /api/appointments/patient/:patientId` - Get patient appointments (Protected)
- `GET /api/appointments/doctor/:doctorId` - Get doctor appointments (Protected)
- `PUT /api/appointments/:id` - Update appointment (Protected)
- `DELETE /api/appointments/:id` - Cancel appointment (Protected)

### Prescriptions
- `POST /api/prescriptions` - Create prescription (Protected - Doctor)
- `GET /api/prescriptions/patient/:patientId` - Get patient prescriptions (Protected)
- `GET /api/prescriptions/doctor/:doctorId` - Get doctor prescriptions (Protected)
- `GET /api/prescriptions/:id` - Get prescription by ID (Protected)

### Pharmacies
- `GET /api/pharmacies` - Get all pharmacies
- `GET /api/pharmacies/:id` - Get pharmacy by ID
- `GET /api/pharmacies/search/medicine` - Search medicine
- `POST /api/pharmacies/:id/inventory` - Add medicine (Protected - Pharmacist)
- `PUT /api/pharmacies/:id/inventory/:medicineId` - Update medicine (Protected)
- `DELETE /api/pharmacies/:id/inventory/:medicineId` - Delete medicine (Protected)

## 🔐 Authentication

All protected routes require JWT token in header:
```
Authorization: Bearer <your_jwt_token>
```

## 📝 Sample Requests

### Register Patient
```json
POST /api/auth/register
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

### Register Doctor
```json
POST /api/auth/register
{
  "name": "Dr. Smith",
  "email": "drsmith@example.com",
  "password": "password123",
  "phone": "9876543211",
  "role": "doctor",
  "specialization": "Cardiologist",
  "licenseNumber": "DOC123456",
  "experience": 10,
  "consultationFee": 500,
  "address": {
    "city": "Mumbai",
    "state": "Maharashtra"
  }
}
```

### Login
```json
POST /api/auth/login
{
  "email": "john@example.com",
  "password": "password123"
}
```

### Book Appointment
```json
POST /api/appointments
Headers: { "Authorization": "Bearer <token>" }
{
  "patientId": "<patient_id>",
  "doctorId": "<doctor_id>",
  "appointmentDate": "2024-03-20",
  "timeSlot": {
    "startTime": "10:00",
    "endTime": "10:30"
  },
  "chiefComplaint": "Chest pain"
}
```

## 🛠️ Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT (jsonwebtoken)
- **Security**: bcryptjs for password hashing
- **Validation**: express-validator

## 📁 Project Structure

```
Backend/
├── config/
│   └── db.js              # Database connection
├── controllers/
│   ├── auth.controller.js
│   ├── doctor.controller.js
│   ├── patient.controller.js
│   ├── appointment.controller.js
│   ├── prescription.controller.js
│   └── pharmacy.controller.js
├── middleware/
│   └── auth.middleware.js  # JWT verification & authorization
├── models/
│   ├── User.model.js
│   ├── Doctor.model.js
│   ├── Patient.model.js
│   ├── Pharmacy.model.js
│   ├── Appointment.model.js
│   └── Prescription.model.js
├── routes/
│   ├── auth.routes.js
│   ├── doctor.routes.js
│   ├── patient.routes.js
│   ├── appointment.routes.js
│   ├── prescription.routes.js
│   └── pharmacy.routes.js
├── .env.example
├── .gitignore
├── package.json
└── server.js
```

## 🚀 Deployment

### Free Hosting Options

1. **Render.com** (Recommended)
   - Sign up at render.com
   - Connect GitHub repo
   - Add environment variables
   - Deploy!

2. **Railway.app**
   - Similar to Render
   - $5 free credit monthly

3. **Cyclic.sh**
   - Easy one-click deploy
   - Free tier available

## 📊 Testing with Postman/Thunder Client

Import this workspace URL in Postman:
`http://localhost:5000/api`

Test the health endpoint:
```
GET http://localhost:5000/
```

## 🐛 Troubleshooting

### MongoDB Connection Issues
- Check if your IP is whitelisted in MongoDB Atlas
- Verify connection string format
- Ensure username/password are correct

### JWT Token Errors
- Make sure JWT_SECRET is set in .env
- Token format should be: `Bearer <token>`

### Port Already in Use
```bash
# Change PORT in .env file
PORT=5001
```

## 📄 License

MIT
