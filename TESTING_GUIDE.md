# CareConnect - Testing Guide & Demo Data

## 🔧 Fixed Issues

### 1. Appointments Screen Error: "User not found"
**Problem:** Provider was trying to decode user JSON from SharedPreferences, but data was stored as individual fields.  
**Solution:** Updated to use `auth Provider.roleProfileId` which contains the Patient/Doctor profile ID needed for API calls.

### 2. Prescriptions Screen Error  
**Problem:** Was using User ID instead of Patient ID for fetching prescriptions.  
**Solution:** Now fetches patient profile first to get Patient ID, then fetches prescriptions.

###3. Medicines Screen Error
**Problem:** Pharmacy response format mismatch.  
**Solution:** Updated provider to handle both `response['pharmacies']` and `response['data']` formats.

### 4. setState During Build Error
**Problem:** `initState` was calling async methods that triggered `notifyListeners` during widget build.  
**Solution:** Wrapped calls in `WidgetsBinding.instance.addPostFrameCallback`.

---

## 📦 Demo Data

### Pre-seeded Doctors (4 doctors available)

1. **Dr. Sarah Johnson - Cardiologist**
   - Email: `sarah.johnson@hospital.com`
   - Password: `doctor123`
   - Experience: 15 years
   - Fee: $500
   - Location: New York, NY

2. **Dr. Michael Chen - Pediatrician**
   - Email: `michael.chen@hospital.com`
   - Password: `doctor123`
   - Experience: 10 years
   - Fee: $400
   - Location: Los Angeles, CA

3. **Dr. Emily Williams - Dermatologist**
   - Email: `emily.williams@hospital.com`
   - Password: `doctor123`
   - Experience: 8 years
   - Fee: $450
   - Location: Chicago, IL

4. **Dr. James Brown - Orthopedic**
   - Email: `james.brown@hospital.com`
   - Password: `doctor123`
   - Experience: 12 years
   - Fee: $550
   - Location: Houston, TX

### Pre-seeded Pharmacies (3 pharmacies with medicines)

1. **HealthPlus Pharmacy**
   - Email: `contact@healthplus.com`
   - Password: `pharmacy123`
   - Location: New York, NY
   - Medicines: 8 common medicines in stock

2. **MediCare Drugstore**
   - Email: `info@medicare.com`
   - Password: `pharmacy123`
   - Location: Los Angeles, CA
   - Medicines: 8 common medicines in stock

3. **WellLife Pharmacy**
   - Email: `support@welllife.com`
   - Password: `pharmacy123`
   - Location: Chicago, IL
   - Medicines: 8 common medicines in stock

### Available Medicines (in all pharmacies)
- Aspirin (Tablet) - $5.99
- Paracetamol (Tablet) - $3.99
- Ibuprofen (Tablet) - $7.99
- Amoxicillin (Capsule) - $12.99
- Omeprazole (Capsule) - $15.99
- Vitamin D3 (Tablet) - $8.99
- Multivitamin (Tablet) - $11.99
- Cough Syrup (Syrup) - $6.99

---

## 🧪 Complete Testing Workflow

### Phase 1: Patient Registration & Login
1. Open app in Chrome
2. Click "Register"
3. Fill patient details:
   - Name: Test Patient
   - Email: patient@test.com
   - Phone: +1234567899
   - Password: test123
   - Role: Patient
   - Blood Group: O+
   - Date of Birth: 01/01/1990
   - Gender: Male/Female
   - Address: Your address
4. Click Register
5. Login with same credentials

### Phase 2: Find Doctors
1. Click "Find Doctors"
2. Try search by name
3. Filter by specialization (Cardiologist, Pediatrician, etc.)
4. Filter by city
5. Filter by rating (minimum)
6. Click on a doctor card

### Phase 3: Book Appointment
1. View doctor profile details
2. Click "Book Appointment"
3. Select date (not Sunday, not past date)
4. Select time slot (Morning/Afternoon/Evening)
5. Enter reason: "Regular checkup"
6. Click "Book Appointment"
7. Verify success message

### Phase 4: View Appointments
1. Go back to dashboard
2. Click "My Appointments"
3. Verify appointment appears
4. Try filter options:
   - All
   - Upcoming
   - Completed
   - Cancelled
5. View appointment details
6. Try canceling an appointment

### Phase 5: Search Medicines
1. Go to dashboard
2. Click "Find Medicine"
3. Search for "Aspirin"
4. View results from different pharmacies
5. View medicine details (price, stock)
6. View pharmacy contact info
7. Try "Call Pharmacy" button
8. Try "Get Directions" button

### Phase 6: Medical History
1. Go to dashboard
2. Click "Medical History"
3. View personal information
4. Check blood group display
5. View medical conditions (if added during registration)
6. View allergies
7. View current medications
8. Try "Edit" button

### Phase 7: Doctor Login & Features
1. Logout from patient account
2. Login as doctor (use demo doctor credentials)
3. View doctor dashboard
4. See upcoming appointments
5. View patient details for appointments
6. Create prescription for a patient
7. View patient medical history

### Phase 8: Pharmacist Login & Features
1. Logout from doctor account
2. Login as pharmacist (use demo pharmacy credentials)
3. View pharmacist dashboard
4. View inventory
5. Check medicine stock levels
6. Update stock quantities
7. Add new medicine
8. View prescription requests

---

## 🐛 Known Issues & Workarounds

### Issue: No prescriptions showing
**Why:** Prescriptions need to be created by doctors for patients  
**Workaround:** Login as doctor → create prescription for test patient

### Issue: Medical history incomplete
**Why:** Additional data needs to be filled during/after registration  
**Workaround:** Use "Edit" button to update medical history

### Issue: No recent activity
**Why:** Recent activity requires actual appointments/prescriptions  
**Workaround:** Book appointments and create prescriptions to see activity

---

## 📊 API Endpoints Working

✅ POST `/api/auth/register` - User registration  
✅ POST `/api/auth/login` - User login  
✅ GET `/api/doctors` - Get all doctors with filters  
✅ GET `/api/doctors/:id` - Get doctor details  
✅ POST `/api/appointments` - Create appointment  
✅ GET `/api/appointments/patient/:patientId` - Get patient appointments  
✅ PUT `/api/appointments/:id` - Update appointment  
✅ GET `/api/pharmacies` - Get all pharmacies  
✅ GET `/api/prescriptions/patient/:patientId` - Get patient prescriptions  
✅ GET `/api/patients/user/:userId` - Get patient profile  

---

## 🚀 Next Steps

1. **Test all patient features** with the fixes
2. **Complete doctor module** (partially done - needs UI screens)
3. **Complete pharmacist module** (partially done - needs UI screens)
4. **Add error boundaries** for better error handling
5. **Add loading states** improvements
6. **Implement pagination** for large lists
7. **Add image upload** for profiles and prescriptions
8. **Deploy to production** (Render for backend, Firebase for frontend)

---

## 📝 Developer Notes

- Backend running on: `http://localhost:5000`
- Frontend running on: Chrome (Flutter web)
- Database: MongoDB Atlas (careconnect database)
- Authentication: JWT tokens stored in SharedPreferences
- State Management: Provider pattern

### Important Code Locations:
- Patient screens: `Frontend/lib/screens/patient/`
- Providers: `Frontend/lib/providers/`
- API service: `Frontend/lib/services/api_service.dart`
- Backend controllers: `Backend/controllers/`
- Models: `Backend/models/` and `Frontend/lib/models/`

---

**Last Updated:** November 17, 2025  
**Status:** Patient module fully functional, Doctor/Pharmacist modules need UI completion
