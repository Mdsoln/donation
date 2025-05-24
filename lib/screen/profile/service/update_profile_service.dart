
import 'dart:convert';

import 'package:donor_app/screen/profile/module/profile_request.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/profile_response.dart';

class UpdateProfile{

  final String baseUrl = "http://192.168.78.217:8080/api/v1/donor";

  Future<ProfileResponse> updateProfile(ProfileRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("No token found in SharedPreferences");
    }
    final decoded = JwtDecoder.decode(token);
    final donorId = decoded['userId'];
    final String url = "$baseUrl/$donorId/update-profile";

    final uri = Uri.parse(url);
    final multipartRequest = http.MultipartRequest('POST', uri);

    multipartRequest.headers['Authorization'] = 'Bearer $token';

    multipartRequest.fields['fullname'] = request.fullname;
    multipartRequest.fields['email'] = request.email;
    multipartRequest.fields['phone'] = request.phone;
    multipartRequest.fields['gender'] = request.gender;
    multipartRequest.fields['birthdate'] = DateFormat('yyyy-MM-dd').format(request.birthdate!);
    multipartRequest.fields['height'] = request.height.toString();
    multipartRequest.fields['weight'] = request.weight.toString();

    if (request.profileImage != null && request.profileImage!.path.isNotEmpty) {
      final extension = request.profileImage!.path.split('.').last.toLowerCase();
      MediaType? mediaType;

      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mediaType = MediaType('image', 'jpeg');
          break;
        case 'png':
          mediaType = MediaType('image', 'png');
          break;
        default:
          throw Exception('Unsupported image format');
      }

      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'profileImage',
          request.profileImage!.path,
          contentType: mediaType,
        ),
      );
    }

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return ProfileResponse.fromJson(data);
    } else {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'] ?? 'Unknown error occurred';
      throw Exception(errorMessage);
    }
  }

}