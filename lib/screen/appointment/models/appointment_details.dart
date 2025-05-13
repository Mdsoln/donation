
class AppointmentDetails {
  final String hospitalName;
  final String address;
  final String date;
  final String time;
  final String status;

  AppointmentDetails({
    required this.hospitalName,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentDetails(
      hospitalName: json['hospitalName'],
      address: json['address'],
      date: json['date'],
      time: json['timeRange'],
      status: json['status'],
    );
  }

}