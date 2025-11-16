import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api_constants.dart';
import '../models/appointment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get error => _errorMessage;

  // Create appointment
  Future<bool> createAppointment(Map<String, dynamic> appointmentData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiService.post(
        ApiConstants.appointments,
        appointmentData,
        requiresAuth: true,
      );

      if (response['success']) {
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

  // Get patient appointments (convenience method)
  Future<void> getPatientAppointments() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) {
        throw Exception('User not found');
      }
      
      final user = json.decode(userJson);
      final response = await ApiService.get(
        '/appointments/patient/${user['id']}',
        requiresAuth: true,
      );

      if (response['success']) {
        _appointments = (response['appointments'] as List)
            .map((apt) => Appointment.fromJson(apt))
            .toList();
        _errorMessage = '';
      } else {
        _errorMessage = response['message'] ?? 'Failed to load appointments';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get patient appointments
  Future<void> fetchPatientAppointments(String patientId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiService.get(
        ApiConstants.patientAppointments(patientId),
        requiresAuth: true,
      );

      if (response['success']) {
        _appointments = (response['data'] as List)
            .map((apt) => Appointment.fromJson(apt))
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

  // Get doctor appointments
  Future<void> fetchDoctorAppointments(String doctorId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiService.get(
        ApiConstants.doctorAppointments(doctorId),
        requiresAuth: true,
      );

      if (response['success']) {
        _appointments = (response['data'] as List)
            .map((apt) => Appointment.fromJson(apt))
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

  // Update appointment
  Future<bool> updateAppointment(String appointmentId, Map<String, dynamic> updates) async {
    _errorMessage = '';
    try {
      final response = await ApiService.put(
        ApiConstants.updateAppointment(appointmentId),
        updates,
        requiresAuth: true,
      );

      if (response['success']) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Cancel appointment
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      final response = await ApiService.put(
        '/appointments/$appointmentId',
        {'status': 'cancelled'},
        requiresAuth: true,
      );

      if (response['success']) {
        // Update local state
        final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
        if (index != -1) {
          _appointments[index] = Appointment.fromJson(response['appointment']);
        }
        notifyListeners();
      } else {
        throw Exception(response['message'] ?? 'Failed to cancel appointment');
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
