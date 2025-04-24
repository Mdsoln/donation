import 'hospital_card_model.dart';

class AppointmentCard {
  final HospitalResponse hospital;
  final String date;
  final String timeRange;
  final int dayToGo;

  AppointmentCard({
    required this.hospital,
    required this.date,
    required this.timeRange,
    required this.dayToGo,
  });

  factory AppointmentCard.fromJson(Map<String, dynamic> json) {
    return AppointmentCard(
      hospital: HospitalResponse.fromJson(json['hospital']),
      date: json['date'] ?? '',
      timeRange: json['timeRange'] ?? '',
      dayToGo: json['dayToGo'] ?? 0,
    );
  }
}
