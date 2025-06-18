import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/hospital_model.dart';
import '../models/slot_model.dart';
import 'appointment_list_details.dart';


class SlotSelectionScreen extends StatefulWidget {
  final Hospital hospital;

  const SlotSelectionScreen({super.key, required this.hospital});

  @override
  State<SlotSelectionScreen> createState() => _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends State<SlotSelectionScreen> {
  int? selectedSlotIndex;
  List<Slot> availableSlots = [];
  bool isLoading = true;
  String errorMessage = '';
  String? infoMessage;
  final String baseUrl = "http://192.168.223.49:8080/api/v1/donor";

  @override
  void initState() {
    super.initState();
    _fetchAvailableSlots();
  }

  Future<void> _fetchAvailableSlots() async {
    try {

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/${widget.hospital.hospitalId}/slots'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          availableSlots = data.map((json) => Slot.fromJson(json)).toList();
          isLoading = false;
          infoMessage = null;
        });
      } else if (response.statusCode == 204) {
        setState(() {
          availableSlots = [];
          isLoading = false;
          infoMessage = 'No available slots at this time';
        });
      } else {
        throw Exception('Failed to load slots: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading slots: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Make a Schedule',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (availableSlots.isEmpty) {
      return Center(child: Text('No available slots found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.hospital.hospitalName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Available Time Slots For Donation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Select and Schedule the appointment',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          // Slot List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: availableSlots.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildSlotCard(availableSlots[index], index);
            },
          ),
          const SizedBox(height: 24),
          // Schedule Now Button
          _buildScheduleButton(),
        ],
      ),
    );
  }

  Widget _buildSlotCard(Slot slot, int index) {
    final isSelected = selectedSlotIndex == index;
    final isAvailable = slot.isAvailable;

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.red[50] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? Colors.red[700]!
              : isAvailable
              ? Colors.grey[300]!
              : Colors.grey[100]!,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isAvailable ? () {
          setState(() {
            selectedSlotIndex = index;
          });
        } : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: isSelected
                    ? Colors.red[700]
                    : isAvailable
                    ? Colors.grey
                    : Colors.grey[300],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDay(slot.startTime),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isAvailable ? Colors.black : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatTime(slot.startTime)} - ${_formatTime(slot.endTime)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isAvailable ? Colors.grey[700] : Colors.grey[400],
                      ),
                    ),
                    if (!isAvailable)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Fully Booked',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Colors.red[700]
                      : isAvailable
                      ? Colors.grey[300]
                      : Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: isAvailable ? () {
                  setState(() {
                    selectedSlotIndex = index;
                  });
                } : null,
                child: Text(
                  isAvailable ? 'Select' : 'Full',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: selectedSlotIndex != null
            ? () => _showConfirmationDialog()
            : null,
        child: Text(
          'Schedule Now',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    final selectedSlot = availableSlots[selectedSlotIndex!];
    final date = selectedSlot.startTime;
    final formattedDate =
        '${_formatDay(date)} ${date.day} ${_monthName(date.month)} ${date.year}';
    final timeRange =
        '${_formatTime(selectedSlot.startTime)} - ${_formatTime(selectedSlot.endTime)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your Appointment Is Scheduled As',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                _buildDetailRow('Center', widget.hospital.hospitalName),
                _buildDetailRow('Location', widget.hospital.hospitalAddress),
                _buildDetailRow('Distance', '${widget.hospital.distanceKm} km'),
                _buildDetailRow('Time', '$formattedDate\n$timeRange'),

                const SizedBox(height: 24),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _scheduleAppointment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              child: Image.asset(
                'assets/animation/ezgif.com-resize.gif',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Congratulations",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your appointment has been scheduled successfully.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyAppointmentScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "OKAY",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDay(DateTime date) {
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][date.weekday - 1];
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _scheduleAppointment() async {
    if (selectedSlotIndex == null) return;

    final selectedSlot = availableSlots[selectedSlotIndex!];

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final decoded = JwtDecoder.decode(token!);
      final donorId = decoded['userId'];

      final response = await http.post(
        Uri.parse('$baseUrl/make-appointment'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'hospitalId': widget.hospital.hospitalId,
          'slotId': selectedSlot.slotId,
          'donorId': donorId,
        }),
      );
      if (kDebugMode) {
        print("user ID: $donorId");
        print("hospital ID: ${widget.hospital.hospitalId}");
        print("slot ID: ${selectedSlot.slotId}");
      }
      if (response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        throw Exception(errorMessage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}