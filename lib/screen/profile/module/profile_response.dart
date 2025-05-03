
class ProfileResponse{
  final String fullname;
  final String email;
  final String gender;
  final String phone;
  final DateTime? birthdate;
  final double height;
  final double weight;
  final String profileImage;

  ProfileResponse({
    required this.fullname,
    required this.email,
    required this.gender,
    required this.phone,
    required this.birthdate,
    required this.height,
    required this.weight,
    required this.profileImage,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      height: json['height']?.toDouble() ?? 0.0,
      weight: json['weight']?.toDouble() ?? 0.0,
      profileImage: json['profileImage'] ?? '',
    );
  }

}
