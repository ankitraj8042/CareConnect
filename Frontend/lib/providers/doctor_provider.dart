import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api_constants.dart';
import '../models/doctor_model.dart';

class DoctorProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  Doctor? _selectedDoctor;
  bool _isLoading = false;
  String? _errorMessage;

  List<Doctor> get doctors => _doctors;
  Doctor? get selectedDoctor => _selectedDoctor;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage ?? '';

  // Get all doctors with location-based sorting
  Future<void> fetchDoctorsWithLocation({
    required double latitude,
    required double longitude,
    String? specialization,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String url = '${ApiConstants.doctors}/nearby?latitude=$latitude&longitude=$longitude';
      
      if (specialization != null && specialization.isNotEmpty) {
        url += '&specialization=$specialization';
      }

      final response = await ApiService.get(url);

      if (response['success']) {
        _doctors = (response['data'] as List)
            .map((doc) => Doctor.fromJson(doc))
            .toList();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all doctors with optional filters
  Future<void> fetchDoctors({
    String? specialization,
    String? city,
    String? search,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String url = ApiConstants.doctors;
      List<String> params = [];

      if (specialization != null && specialization.isNotEmpty) {
        params.add('specialization=$specialization');
      }
      if (city != null && city.isNotEmpty) {
        params.add('city=$city');
      }
      if (search != null && search.isNotEmpty) {
        params.add('search=$search');
      }

      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }

      final response = await ApiService.get(url);

      if (response['success']) {
        _doctors = (response['data'] as List)
            .map((doc) => Doctor.fromJson(doc))
            .toList();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get doctor by ID
  Future<void> fetchDoctorById(String doctorId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.get(ApiConstants.doctorById(doctorId));

      if (response['success']) {
        _selectedDoctor = Doctor.fromJson(response['data']);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get specializations
  Future<List<String>> fetchSpecializations() async {
    try {
      final response = await ApiService.get(ApiConstants.specializations);

      if (response['success']) {
        return List<String>.from(response['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  void clearSelectedDoctor() {
    _selectedDoctor = null;
    notifyListeners();
  }
}
