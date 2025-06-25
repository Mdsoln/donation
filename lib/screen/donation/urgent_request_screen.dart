import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UrgentRequestScreen extends StatelessWidget {
  // Example data, ideally you'd get this from a backend API
  final List<BloodRequest> requests = [
    BloodRequest(
      name: "Muddy Ramadhan",
      location: "Mwananyamala Hospital",
      bloodType: "A+",
      timeAgo: "1 hrs ago",
      condition: "Critical condition, urgent donation required",
    ),
    BloodRequest(
      name: "Aisha Mzava",
      location: "Aga Khan Hospital",
      bloodType: "AB-",
      timeAgo: "2 hrs ago",
      condition: "Critical condition, urgent donation required",
    ),
    BloodRequest(
      name: "Amon Amon",
      location: "Aga Khan Hospital",
      bloodType: "AB-",
      timeAgo: "2 hrs ago",
      condition: "Critical condition, urgent donation required",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Urgent Blood Request",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        leading: BackButton(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Alert Icon
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/alert.png',
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "These people are urgently in need of your blood please Accept the request to save life of others",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Request cards
            Expanded(
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  return _buildRequestCard(requests[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(BloodRequest request) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Blood Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.bloodType,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Location: ${request.location}",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            Text(
              "${request.condition}\nRequested ${request.timeAgo}.",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Handle accept action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Accept Request",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BloodRequest {
  final String name;
  final String location;
  final String bloodType;
  final String timeAgo;
  final String condition;

  BloodRequest({
    required this.name,
    required this.location,
    required this.bloodType,
    required this.timeAgo,
    required this.condition,
  });
}
