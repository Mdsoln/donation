
class Slot {
  final int slotId;
  final int hospitalId;
  final DateTime startTime;
  final DateTime endTime;
  final int maxCapacity;
  final int currentBookings;

  Slot({
    required this.slotId,
    required this.hospitalId,
    required this.startTime,
    required this.endTime,
    required this.maxCapacity,
    required this.currentBookings,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      slotId: json['slotId'],
      hospitalId: json['hospitalId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      maxCapacity: json['maxCapacity'],
      currentBookings: json['currentBookings'],
    );
  }

  bool get isAvailable => currentBookings < maxCapacity;
}