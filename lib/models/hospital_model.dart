
class Hospital {
  final int hospitalId;
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalCity;
  final double? latitude;
  final double? longitude;
  final bool isNearby;

  Hospital({
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.hospitalCity,
    this.latitude,
    this.longitude,
    this.isNearby = false,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      hospitalId: json['hospitalId'],
      hospitalName: json['hospitalName'],
      hospitalAddress: json['hospitalAddress'],
      hospitalCity: json['hospitalCity'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}