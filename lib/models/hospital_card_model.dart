import 'dart:ffi';

class HospitalResponse{
  final Long id;
  final String hospitalName;
  final String hospitalAddress;

  HospitalResponse({
    required this.id,
    required this.hospitalName,
    required this.hospitalAddress,
  });

  factory HospitalResponse.fromJson(Map<String, dynamic> json) {
    return HospitalResponse(
      id: json['id'],
      hospitalName: json['hospitalName'],
      hospitalAddress: json['hospitalAddress'],);
  }

}