import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../config/api_constants.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  String? _roleProfileId;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  String? get roleProfileId => _roleProfileId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _user != null;

  // Register
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.post(ApiConstants.register, userData);

      if (response['success']) {
        _user = User.fromJson(response['data']['user']);
        _token = response['data']['token'];
        _roleProfileId = response['data']['roleProfileId'];

        // Save to local storage
        await _saveToStorage();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.post(
        ApiConstants.login,
        {'email': email, 'password': password},
      );

      if (response['success']) {
        _user = User.fromJson(response['data']['user']);
        _token = response['data']['token'];
        _roleProfileId = response['data']['roleProfileId'];

        // Save to local storage
        await _saveToStorage();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _user = null;
    _token = null;
    _roleProfileId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // Load user from local storage
  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _roleProfileId = prefs.getString('roleProfileId');

    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = User.fromJson({
        'id': prefs.getString('userId'),
        'name': prefs.getString('userName'),
        'email': prefs.getString('userEmail'),
        'phone': prefs.getString('userPhone'),
        'role': prefs.getString('userRole'),
        'isVerified': prefs.getBool('isVerified') ?? false,
        'profileImage': prefs.getString('profileImage'),
      });
    }

    notifyListeners();
  }

  // Save to local storage
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('roleProfileId', _roleProfileId ?? '');
    await prefs.setString('userId', _user!.id);
    await prefs.setString('userName', _user!.name);
    await prefs.setString('userEmail', _user!.email);
    await prefs.setString('userPhone', _user!.phone);
    await prefs.setString('userRole', _user!.role);
    await prefs.setBool('isVerified', _user!.isVerified);
    if (_user!.profileImage != null) {
      await prefs.setString('profileImage', _user!.profileImage!);
    }
  }
}
