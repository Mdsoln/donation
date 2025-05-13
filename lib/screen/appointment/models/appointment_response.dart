
import 'appointment_details.dart';

class AppointmentResponse{
  final int total;
  final int attended;
  final int expired;
  final List<AppointmentDetails> appointments;

  AppointmentResponse({
    required this.total,
    required this.attended,
    required this.expired,
    required this.appointments,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
     return AppointmentResponse(
      total: json['total'],
      attended: json['attended'],
      expired: json['expired'],
      appointments: (json['appointments'] as List<dynamic>)
          .map((appointment) => AppointmentDetails.fromJson(appointment))
          .toList()
     );
  }

}