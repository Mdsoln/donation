import 'package:flutter/material.dart';

import '../../profile/dashboard_screen.dart';
import '../models/appointment_details.dart';
import '../models/appointment_response.dart';

class MyAppointmentScreen extends StatefulWidget {
  final AppointmentResponse response;

  const MyAppointmentScreen({Key? key, required this.response}) : super(key: key);

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    final appointments = widget.response.appointments;
    final total = widget.response.total.toString();
    final attended = widget.response.attended.toString();
    final expired = widget.response.expired.toString();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) =>DashboardScreen(),
            ),
          ),
        ),
        title: const Text('My Appointments', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard('Total', total),
                _buildSummaryCard('Attended', attended),
                _buildSummaryCard('Expired', expired),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final item = appointments[index];
                  return _buildAppointmentCard(item);
                },
              ),
            ),
            const SizedBox(height: 10),
            const Icon(Icons.arrow_downward, size: 30, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFEAD7D1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildAppointmentCard(AppointmentDetails item) {
    Color statusColor;
    String statusLabel = item.status;

    switch (statusLabel.toLowerCase()) {
      case 'attended':
        statusColor = Colors.green;
        break;
      case 'expired':
        statusColor = Colors.red;
        break;
      case 'upcoming':
        statusColor = Colors.pink;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.hospitalName, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(item.address),
            const SizedBox(height: 4),
            Text('${item.date}\n${item.time}'),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
