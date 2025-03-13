
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/auth_model.dart';

class AuthService{
    static const String _baseUrl = "http://192.168.125.49:8080/api/v1/donorapp";

    Future<AuthResponse> login(AuthRequest request) async {
      final Uri url = Uri.parse("$_baseUrl/login");

        final response = await http.post(
            url,
            headers: {
            "Content-Type": "application/json",
            },
            body: jsonEncode(request.toJson()),
        );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);

      } else {

        final responseBody = jsonDecode(response.body);
        final responseError = responseBody["error"] ?? "Registration failed. Please try again.";
        throw http.Response(responseError, response.statusCode);
      }
    }
}