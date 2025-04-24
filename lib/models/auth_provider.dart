import 'package:flutter/material.dart';
import 'package:donor_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_model.dart';

class AuthProvider with ChangeNotifier {
  AuthResponse? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  AuthResponse? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final AuthService _authService = AuthService();

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        AuthRequest(username: username, password: password),
      );

      _user = response;
      _token = response.token;

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      await prefs.setString('username', response.username);
      await prefs.setString('bloodGroup', response.bloodGroup);
      await prefs.setInt('donations', response.donations);
      await prefs.setString('picture', response.picture);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _token = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      _token = token;
      _user = AuthResponse(
        message: '',
        token: token,
        username: prefs.getString('username') ?? '',
        bloodGroup: prefs.getString('bloodGroup') ?? '',
        donations: prefs.getInt('donations') ?? 0,
        picture: prefs.getString('picture') ?? '',
        latestAppointment: null, // You'll need to handle this separately
      );
      notifyListeners();
    }
  }
}