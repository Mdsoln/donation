import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_model.dart';


class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final String baseUrl = "http://192.168.179.49:8080/api/v1/donor";

  Future<AuthResponse> login(AuthRequest request) async {
    final String url = "$baseUrl/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw AuthException("Wrong username or password");
      } else if (response.statusCode == 500) {
        throw AuthException("Server error. Please try again later.");
      } else {
        throw AuthException("Failed to login: ${response.statusCode}");
      }
    } on SocketException {
      throw AuthException("No internet connection. Please check your network.");
    } on TimeoutException {
      throw AuthException("Request timed out. Please try again.");
    } on HttpException {
      throw AuthException("Could not connect to the server.");
    } catch (e) {
      throw AuthException("Unexpected error: $e");
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
