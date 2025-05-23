import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String _baseUrl = "http://192.168.255.217:8080/api/v1/donor";

  Future<Map<String, dynamic>> registerDonor({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String ageGroup,
  }) async {
    final url = Uri.parse("$_baseUrl/register-donor");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "phone": phone,
          "password": password,
          "ageGroup": ageGroup,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Registration successful',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}