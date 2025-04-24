
import 'appointment_card_model.dart';

class AuthRequest {
  final String username;
  final String password;

  AuthRequest({
    required this.username,
    required this.password
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      };
  }

}

class AuthResponse {
  final String message;
  final String token;
  final String username;
  final String bloodGroup;
  final int donations;
  final String picture;
  final AppointmentCard? latestAppointment;

  AuthResponse({
    required this.message,
    required this.token,
    required this.username,
    required this.bloodGroup,
    required this.donations,
    required this.picture,
    this.latestAppointment,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      username: json['username'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      donations: json['donations'] ?? 0,
      picture: json['picture'] ?? '',
      latestAppointment: json['latestAppointment'] != null
          ? AppointmentCard.fromJson(json['latestAppointment'])
          : null,
    );
  }
}
