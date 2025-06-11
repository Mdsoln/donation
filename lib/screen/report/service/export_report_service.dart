
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/report_request_model.dart';

class ExportReportService {
  final String _baseUrl = 'http://192.168.208.49:8080/api/v1/reports';

  Future<Map<String, dynamic>> exportReport(ReportRequest request, String format) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final decoded = JwtDecoder.decode(token);
      final donorId = decoded['userId'];

      // Update the format in the request
      final Map<String, dynamic> requestBody = request.toJson();
      requestBody['reportFormat'] = format;

      final response = await http.post(
        Uri.parse('$_baseUrl/donor/$donorId/export/${format.toLowerCase()}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Save file and open it
        final directory = await getApplicationDocumentsDirectory();
        final extension = format.toLowerCase() == 'pdf' ? 'pdf' : 'xlsx';
        final file = File('${directory.path}/donor_report.$extension');
        await file.writeAsBytes(response.bodyBytes);

        // Open the file
        await OpenFile.open(file.path);

        return {
          'success': true,
          'filePath': file.path,
          'error': null
        };
      } else {
        return {
          'success': false,
          'filePath': null,
          'error': 'Error exporting report: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'filePath': null,
        'error': 'Error exporting report: $e'
      };
    }
  }
}
