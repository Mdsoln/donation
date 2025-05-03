
import 'dart:convert';

import 'package:donor_app/screen/profile/module/profile_request.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/profile_response.dart';

class UpdateProfile{

  final String baseUrl = "http://192.168.1.194:8080/api/v1/donor";

  Future<ProfileResponse> updateProfile(ProfileRequest request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final decoded = JwtDecoder.decode(token!);
      final donorId = decoded['userId'];
      final String url = "$baseUrl/$donorId/update-profile";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return ProfileResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        throw Exception(errorMessage);
      }
  }
}