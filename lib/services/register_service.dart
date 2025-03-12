import 'dart:convert';

import 'package:http/http.dart' as http;

class RegisterService{
        static const String _baseUrl = "http://192.168.122.49:8080/api/v1/donorapp";

        Future<Map<String, dynamic>> registerDonor({
          required String fullName,
          required String email,
          required String phone,
          required String password,
        }) async {
          final url = Uri.parse("$_baseUrl/register-donor");

          final response = await http.post(
            url,
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "fullName": fullName,
              "email": email,
              "phone": phone,
              "password": password,
            }),
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