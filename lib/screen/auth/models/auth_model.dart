
import '../../appointment/models/appointment_card_model.dart';

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
  final String gender;
  final String dateOfBirth;
  final String mobile;
  final double height;
  final double weight;
  final String lastDonation;
  final AppointmentCard? latestAppointment;

  AuthResponse({
    required this.message,
    required this.token,
    required this.username,
    required this.bloodGroup,
    required this.donations,
    required this.picture,
    required this.gender,
    required this.dateOfBirth,
    required this.mobile,
    required this.height,
    required this.weight,
    required this.lastDonation,
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
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      mobile: json['mobile'] ?? '',
      height: json['height']?.toDouble() ?? 0.0,
      weight: json['weight']?.toDouble() ?? 0.0,
      lastDonation: json['lastDonation'] ?? '',
      latestAppointment: json['latestAppointment'] != null
          ? AppointmentCard.fromJson(json['latestAppointment'])
          : null,
    );
  }
}
