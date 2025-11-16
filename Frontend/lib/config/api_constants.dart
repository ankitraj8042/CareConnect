class ApiConstants {
  // Change this to your backend URL
  // For local development: http://localhost:5000
  // For deployed backend: https://your-app.onrender.com
  static const String baseUrl = 'http://localhost:5000/api';
  
  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String getMe = '$baseUrl/auth/me';
  
  // Doctor endpoints
  static const String doctors = '$baseUrl/doctors';
  static String doctorById(String id) => '$baseUrl/doctors/$id';
  static String doctorAvailability(String id) => '$baseUrl/doctors/$id/availability';
  static const String specializations = '$baseUrl/doctors/specializations/list';
  
  // Patient endpoints
  static const String patients = '$baseUrl/patients';
  static String patientById(String id) => '$baseUrl/patients/$id';
  static String addMedicalHistory(String id) => '$baseUrl/patients/$id/medical-history';
  static String addDocument(String id) => '$baseUrl/patients/$id/documents';
  
  // Appointment endpoints
  static const String appointments = '$baseUrl/appointments';
  static String patientAppointments(String patientId) => 
      '$baseUrl/appointments/patient/$patientId';
  static String doctorAppointments(String doctorId) => 
      '$baseUrl/appointments/doctor/$doctorId';
  static String updateAppointment(String id) => '$baseUrl/appointments/$id';
  
  // Prescription endpoints
  static const String prescriptions = '$baseUrl/prescriptions';
  static String patientPrescriptions(String patientId) => 
      '$baseUrl/prescriptions/patient/$patientId';
  static String doctorPrescriptions(String doctorId) => 
      '$baseUrl/prescriptions/doctor/$doctorId';
  static String prescriptionById(String id) => '$baseUrl/prescriptions/$id';
  
  // Pharmacy endpoints
  static const String pharmacies = '$baseUrl/pharmacies';
  static String pharmacyById(String id) => '$baseUrl/pharmacies/$id';
  static const String searchMedicine = '$baseUrl/pharmacies/search/medicine';
  static String addMedicine(String id) => '$baseUrl/pharmacies/$id/inventory';
  static String updateMedicine(String id, String medicineId) => 
      '$baseUrl/pharmacies/$id/inventory/$medicineId';
}
