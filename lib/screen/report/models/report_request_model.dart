import 'package:intl/intl.dart';

class ReportRequest {
  final String reportType;
  final String reportFormat;
  final int? year;
  final int? quarter;
  final int? yearOnly;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool includeAppointmentStats;
  final bool includeRequestStats;
  final bool includeHospitalBreakdown;
  
  ReportRequest({
    required this.reportType,
    required this.reportFormat,
    this.year,
    this.quarter,
    this.yearOnly,
    this.startDate,
    this.endDate,
    required this.includeAppointmentStats,
    required this.includeRequestStats,
    required this.includeHospitalBreakdown,
  });
  
  Map<String, dynamic> toJson() {
    final requestBody = <String, dynamic>{
      'reportType': reportType,
      'reportFormat': reportFormat,
      'includeAppointmentStats': includeAppointmentStats,
      'includeRequestStats': includeRequestStats,
      'includeHospitalBreakdown': includeHospitalBreakdown,
    };

    if (reportType == 'QUARTERLY') {
      requestBody['year'] = year;
      requestBody['quarter'] = quarter;
    } else if (reportType == 'YEARLY') {
      requestBody['yearOnly'] = yearOnly;
    } else if (reportType == 'CUSTOM') {
      requestBody['startDate'] = startDate != null 
          ? DateFormat('yyyy-MM-dd').format(startDate!) 
          : null;
      requestBody['endDate'] = endDate != null 
          ? DateFormat('yyyy-MM-dd').format(endDate!) 
          : null;
    }

    return requestBody;
  }
}