import 'package:intl/intl.dart';

class DonorReport {
  final String donorName;
  final String reportPeriod;
  final int totalDonations;
  final double totalVolumeMl;
  final String? firstDonationDate;
  final String? lastDonationDate;
  
  // Appointment statistics
  final int totalAppointments;
  final int completedAppointments;
  final int scheduledAppointments;
  final int expiredAppointments;
  final int cancelledAppointments;
  
  // Hospital breakdown
  final List<HospitalData> hospitalData;
  
  DonorReport({
    required this.donorName,
    required this.reportPeriod,
    required this.totalDonations,
    required this.totalVolumeMl,
    this.firstDonationDate,
    this.lastDonationDate,
    required this.totalAppointments,
    required this.completedAppointments,
    required this.scheduledAppointments,
    required this.expiredAppointments,
    required this.cancelledAppointments,
    required this.hospitalData,
  });
  
  factory DonorReport.fromJson(Map<String, dynamic> json) {
    List<HospitalData> hospitalDataList = [];
    if (json['hospitalData'] != null) {
      hospitalDataList = (json['hospitalData'] as List)
          .map((item) => HospitalData.fromJson(item))
          .toList();
    }
    
    return DonorReport(
      donorName: json['donorName'] ?? '',
      reportPeriod: json['reportPeriod'] ?? '',
      totalDonations: json['totalDonations'] ?? 0,
      totalVolumeMl: json['totalVolumeMl']?.toDouble() ?? 0.0,
      firstDonationDate: json['firstDonationDate'],
      lastDonationDate: json['lastDonationDate'],
      totalAppointments: json['totalAppointments'] ?? 0,
      completedAppointments: json['completedAppointments'] ?? 0,
      scheduledAppointments: json['scheduledAppointments'] ?? 0,
      expiredAppointments: json['expiredAppointments'] ?? 0,
      cancelledAppointments: json['cancelledAppointments'] ?? 0,
      hospitalData: hospitalDataList,
    );
  }
  
  String formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(date);
  }
}

class HospitalData {
  final String hospitalName;
  final int donations;
  final double volumeMl;
  
  HospitalData({
    required this.hospitalName,
    required this.donations,
    required this.volumeMl,
  });
  
  factory HospitalData.fromJson(Map<String, dynamic> json) {
    return HospitalData(
      hospitalName: json['hospitalName'] ?? '',
      donations: json['donations'] ?? 0,
      volumeMl: json['volumeMl']?.toDouble() ?? 0.0,
    );
  }
}