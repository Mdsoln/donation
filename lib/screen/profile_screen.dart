import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // Profile Image
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),

            const SizedBox(height: 8),

            // Name & Last Donation Date
            const Text(
              "Mdsoln",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Last Donation: Dec, 2024",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            // Donations, Requests, Appointments
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _InfoCard(title: "Donations", value: "08"),
                _InfoCard(title: "Request", value: "03"),
                _InfoCard(title: "Appointments", value: "01"),
              ],
            ),

            const SizedBox(height: 10),

            // Gender & Blood Group
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  // Gender Section
                  _IconWithLabelRow(
                    icon: Icons.female,
                    label: "Gender",
                    value: "Female",
                    iconColor: Colors.pink,
                  ),
                  // Blood Group Section
                  _IconWithLabelRow(
                    icon: Icons.bloodtype,
                    label: "Blood Group",
                    value: "A+",
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  _DetailTile(icon: Icons.location_on, title: "Location", value: "Kijlronyama"),
                  _DetailTile(icon: Icons.calendar_today, title: "Date of Birth", value: "24th Aug, 2002"),
                  _DetailTile(icon: Icons.phone, title: "Phone Number", value: "+255755379158"),
                  _DetailTile(icon: Icons.email, title: "Email Address", value: "aishamusasmzava@gmail.com"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Height & Weight
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  // Height Section
                  _IconWithLabelRow(
                    icon: Icons.height,
                    label: "Height",
                    value: "59.2",
                    iconColor: Colors.redAccent,
                  ),
                  // Weight Section
                  _IconWithLabelRow(
                    icon: Icons.fitness_center,
                    label: "Weight",
                    value: "62",
                    iconColor: Colors.redAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}

// Widget for Top Info Cards
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Widget for Profile Details with Icons
class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}

// Widget for Gender, Blood Group, Height, Weight (Icon in Row with Labels in Column)
class _IconWithLabelRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _IconWithLabelRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon
        Icon(icon, color: iconColor, size: 30),
        const SizedBox(width: 10),
        // Labels in Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 3),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}