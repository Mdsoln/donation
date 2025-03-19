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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
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
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),

            const SizedBox(height: 10),

            // Name & Last Donation Date
            Text(
              "Mdsoln",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Last Donation: Dec, 2024",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // Donations, Requests, Appointments
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoCard("Donations", "08"),
                _infoCard("Request", "03"),
                _infoCard("Appointments", "01"),
              ],
            ),

            const SizedBox(height: 10),

            // Gender & Blood Group
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconCard(Icons.male, "Gender", "Male", Colors.pink),
                _iconCard(Icons.bloodtype, "Blood Group", "A+", Colors.red),
              ],
            ),

            const SizedBox(height: 10),

            // Details Section
            _detailTile(Icons.location_on, "Location", "Mawasiliano"),
            _detailTile(Icons.calendar_today, "Date of Birth", "3th Aug, 2002"),
            _detailTile(Icons.phone, "Phone Number", "+255717611117"),
            _detailTile(Icons.email, "Email Address", "muddyfakih98@gmail.com"),

            // Height & Weight
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconCard(Icons.height, "Height", "59.2", Colors.redAccent),
                _iconCard(Icons.fitness_center, "Weight", "62", Colors.redAccent),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        onTap: (index){
          //todo: implementing index navigation to Education/resource screen
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          }else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  // Widget for Top Info Cards
  Widget _infoCard(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget for Profile Details with Icons
  Widget _detailTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: Colors.red),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(value),
        ),
      ),
    );
  }

  // Widget for Gender, Blood Group, Height, Weight
  Widget _iconCard(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.grey, fontSize: 12)),
          SizedBox(height: 3),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}