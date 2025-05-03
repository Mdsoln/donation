
import 'dart:io';

class ProfileRequest{
  final String fullname;
  final String email;
  final String phone;
  final DateTime? birthdate;
  final double height;
  final double weight;
  final File? profileImage;

  ProfileRequest({
    required this.fullname,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.height,
    required this.weight,
    this.profileImage,
  });
}

class LocalDate {
}