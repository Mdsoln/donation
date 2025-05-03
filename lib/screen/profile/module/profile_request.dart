
import 'dart:io';

class ProfileRequest{
  final String fullname;
  final String email;
  final String gender;
  final String phone;
  final DateTime? birthdate;
  final double height;
  final double weight;
  final File? profileImage;

  ProfileRequest({
    required this.fullname,
    required this.email,
    required this.gender,
    required this.phone,
    required this.birthdate,
    required this.height,
    required this.weight,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "email": email,
      "gender": gender,
      "phone": phone,
      "birthdate": birthdate?.toIso8601String(),
      "height": height,
      "weight": weight,
      "profileImage": profileImage
    };
  }
}

