
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/donor_report_model.dart';
import '../models/report_request_model.dart';

class GenerateReportService {
  final String _baseUrl = 'http://192.168.223.49:8080/api/v1/reports';

  Future<Map<String, dynamic>> generateReport(ReportRequest request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final decoded = JwtDecoder.decode(token);
      final donorId = decoded['userId'];

      final response = await http.post(
        Uri.parse('$_baseUrl/donor/$donorId'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': DonorReport.fromJson(jsonDecode(response.body)),
          'error': null
        };
      } else {
        return {
          'success': false,
          'data': null,
          'error': 'Error generating report: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'error': 'Error generating report: $e'
      };
    }
  }
}
