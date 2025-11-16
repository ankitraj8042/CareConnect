import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api_constants.dart';
import '../models/pharmacy_model.dart';

class PharmacyProvider extends ChangeNotifier {
  List<Pharmacy> _pharmacies = [];
  List<dynamic> _medicineSearchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Pharmacy> get pharmacies => _pharmacies;
  List<dynamic> get medicineSearchResults => _medicineSearchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get error => _errorMessage;

  // Get all pharmacies (convenience method)
  Future<void> getAllPharmacies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiService.get('/pharmacies');

      if (response['success'] == true || response['pharmacies'] != null) {
        final pharmacyList = response['pharmacies'] ?? response['data'] ?? [];
        _pharmacies = (pharmacyList as List)
            .map((pharmacy) => Pharmacy.fromJson(pharmacy))
            .toList();
        _errorMessage = '';
      } else {
        _errorMessage = response['message'] ?? 'Failed to load pharmacies';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all pharmacies
  Future<void> fetchPharmacies({String? city}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String url = ApiConstants.pharmacies;
      if (city != null && city.isNotEmpty) {
        url += '?city=$city';
      }

      final response = await ApiService.get(url);

      if (response['success']) {
        _pharmacies = (response['data'] as List)
            .map((pharmacy) => Pharmacy.fromJson(pharmacy))
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

  // Search medicine
  Future<void> searchMedicine(String medicineName) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = '${ApiConstants.searchMedicine}?medicineName=$medicineName';
      final response = await ApiService.get(url);

      if (response['success']) {
        _medicineSearchResults = response['data'];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add medicine to inventory
  Future<bool> addMedicine(String pharmacyId, Map<String, dynamic> medicineData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiService.post(
        ApiConstants.addMedicine(pharmacyId),
        medicineData,
        requiresAuth: true,
      );

      if (response['success']) {
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearSearchResults() {
    _medicineSearchResults = [];
    notifyListeners();
  }
}
