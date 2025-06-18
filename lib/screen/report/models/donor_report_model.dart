import 'package:intl/intl.dart';

class DonorReport {
  final String donorName;
  final String bloodGroup;
  final String location;
  final String reportPeriod;
  final int totalDonations;
  final double totalVolumeMl;
  final String? firstDonationDate;
  final String? lastDonationDate;
  final String? eligibleDate;
  final String topDonationCenter;
  final String? mostActiveMonth;
  
  // Appointment statistics
  final int totalAppointments;
  final int completedAppointments;
  final int scheduledAppointments;
  final int expiredAppointments;

  // Urgent request statistics
  
  DonorReport({
    required this.donorName,
    required this.bloodGroup,
    required this.location,
    required this.reportPeriod,
    required this.totalDonations,
    required this.totalVolumeMl,
    this.firstDonationDate,
    this.lastDonationDate,
    this.eligibleDate,
    required this.totalAppointments,
    required this.completedAppointments,
    required this.scheduledAppointments,
    required this.expiredAppointments,
    this.topDonationCenter = '',
    this.mostActiveMonth = '',
  });
  
  factory DonorReport.fromJson(Map<String, dynamic> json) {
    return DonorReport(
      donorName: json['donorName'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      location: json['location'] ?? '',
      reportPeriod: json['reportPeriod'] ?? '',
      totalDonations: json['totalDonations'] ?? 0,
      totalVolumeMl: json['totalVolumeMl']?.toDouble() ?? 0.0,
      firstDonationDate: json['firstDonationDate'],
      lastDonationDate: json['lastDonationDate'],
      eligibleDate: json['eligibleDate'],
      totalAppointments: json['totalAppointments'] ?? 0,
      completedAppointments: json['completedAppointments'] ?? 0,
      scheduledAppointments: json['scheduledAppointments'] ?? 0,
      expiredAppointments: json['expiredAppointments'] ?? 0,
      topDonationCenter: json['topDonationCenter'] ?? '',
      mostActiveMonth: json['mostActiveMonth'],
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