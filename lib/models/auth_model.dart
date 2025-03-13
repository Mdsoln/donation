
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
  final String roles;
  final String email;
  final String phone;
  final HospitalResponse? hospital;

  AuthResponse({
    required this.message,
    required this.token,
    required this.username,
    required this.roles,
    required this.email,
    required this.phone,
    this.hospital,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json["message"] ?? "",
      token: json["token"] ?? "",
      username: json["username"] ?? "",
      roles: json["roles"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      hospital: json["hospital"] != null ? HospitalResponse.fromJson(json["hospital"]) : null,
    );
  }
}

class HospitalResponse {
  final String name;
  final String address;
  final String city;

  HospitalResponse({required this.name, required this.address, required this.city});

  factory HospitalResponse.fromJson(Map<String, dynamic> json) {
    return HospitalResponse(
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
    );
  }
}
