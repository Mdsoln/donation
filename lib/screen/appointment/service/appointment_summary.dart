
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/appointment_response.dart';

class AppointmentHistoryAPI {
  final String baseUrl = "http://192.168.55.49:8080/api/v1/donor";


  Future<AppointmentResponse?> fetchAppointments(String donorId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/appointments/$donorId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return AppointmentResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 204) {
      // No Content — return null so the UI can handle it
      return null;
    } else {
      throw Exception('Failed to load appointments (${response.statusCode})');
    }
  }


}