import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/hospital_model.dart';
import '../models/slot_model.dart';


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
  final String baseUrl = "http://192.168.57.49:8080/api/v1/donorapp";

  @override
  void initState() {
    super.initState();
    _fetchAvailableSlots();
  }

  Future<void> _fetchAvailableSlots() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/${widget.hospital.hospitalId}/slots'),
        headers: {'Accept': 'application/json'},
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
        title: Text('Make a Schedule'),
        backgroundColor: Colors.red[700],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital Info
          Text(
            widget.hospital.hospitalName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.hospital.hospitalAddress,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Available Slots Header
          Text(
            'Available Time Slots For Donation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select and Schedule the appointment',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

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
            ? () => _scheduleAppointment()
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
      // Replace with your actual API endpoint
      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'hospitalId': widget.hospital.hospitalId,
          'slotId': selectedSlot.slotId,
          'donorId': 'YOUR_DONOR_ID', // Get from user session
          'appointmentDate': selectedSlot.startTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        // Success - show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment scheduled successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Return to previous screen
      } else {
        throw Exception('Failed to schedule appointment');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scheduling appointment: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}