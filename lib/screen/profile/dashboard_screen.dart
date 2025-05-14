import 'package:donor_app/screen/profile/profile_screen.dart';
import 'package:donor_app/screen/donation/urgent_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../appointment/models/appointment_card_model.dart';
import '../auth/models/auth_model.dart';
import '../auth/models/auth_provider.dart';
import '../appointment/screen/hospital_selection_screen.dart';
import '../donation/donation_history_screen.dart';
import '../auth/screen/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(user: user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context, user),

            if (user.latestAppointment != null)
              _buildAppointmentCard(user.latestAppointment!),

            _buildQuickActions(context),

            _buildDonationBanner(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
}

  Widget _buildHeaderSection(BuildContext context, AuthResponse user) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Profile Section
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Left Side: Profile Info
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                        radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: user.picture.isNotEmpty
                                ? Image.network(
                              "http://192.168.179.217:8080/images/${user.picture}",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // If the image fails, show a nice person icon
                                return Icon(
                                  Icons.person,
                                  size: 50,
                                );
                              },
                            )
                                : Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            user.username,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Location could be dynamic if available in user model
                    Text(
                      "Kijichonyama",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Right Side: Blood Group and Donations
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    // Blood Group
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 2,
                            height: 55,
                            color: Colors.white.withOpacity(0.5),
                            margin: const EdgeInsets.only(right: 10),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Blood\nGroup",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white60,
                                ),
                              ),
                              Text(
                                user.bloodGroup.isNotEmpty == true ? user.bloodGroup : "N/A",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Donation Times
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 2,
                            height: 55,
                            color: Colors.white.withOpacity(0.5),
                            margin: const EdgeInsets.only(right: 10),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Donation\nTimes",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white60,
                                ),
                              ),
                              Text(
                                "${user.donations}",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentCard appointment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming\nAppointment:",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _countdownBox("${appointment.dayToGo}"),
                    ],
                  ),
                ),
                const SizedBox(width: 10), // spacing between columns
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Attending Location:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${appointment.hospital.hospitalName}\n${appointment.hospital.hospitalAddress}",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${appointment.date}\nTime: ${appointment.timeRange}",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    "Day to go",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle view appointment
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("View"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Helper Widget: Countdown Box
  Widget _countdownBox(String number) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.brown.shade700, width: 3),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade700,
            ),
          ),
        ),
      ],
    );
  }

  // Helper Widget: Action Buttons
  Widget _actionButton(String label, IconData icon, BuildContext context, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red.shade700,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 5),
          Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _actionButton(
            "Find Donation Center",
            Icons.location_on,
            context,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HospitalSelectionScreen()),
            ),
          ),
          _actionButton(
            "Urgent Request",
            Icons.lock,
            context,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UrgentRequestScreen()),
            ),
          ),
          _actionButton(
            "Schedule Appointment",
            Icons.calendar_month,
            context,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HospitalSelectionScreen()),
            ),
          ),
          _actionButton(
            "My Donation",
            Icons.favorite,
            context,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DonationHistoryScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset("assets/images/donation_banner.png", fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.red.shade700,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.book), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
      onTap: (index) {
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
        else if (index == 2) {
          final user = Provider.of<AuthProvider>(context, listen: false).user;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(user: user!)),
          );
        }
      },
    );
  }

class AppDrawer extends StatelessWidget {
  final AuthResponse user;

  const AppDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
            Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 64, 20, 20),
            color: Colors.red.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: user),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: user.picture.isNotEmpty
                          ? Image.network(
                        "http://192.168.179.49:8080/images/${user.picture}",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 50,
                          );
                        },
                      )
                          : Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.username,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.home, "Home", () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                }),
                _buildDrawerItem(Icons.calendar_today, "My Appointment", () {
                  // Handle navigation to appointments
                }),
                _buildDrawerItem(Icons.history, "Donation History", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonationHistoryScreen()),
                  );
                }),
                _buildDrawerItem(Icons.warning, "Urgent Request", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UrgentRequestScreen()),
                  );
                }),
                _buildDrawerItem(Icons.location_on, "Find Donation Centers", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HospitalSelectionScreen()),
                  );
                }),
                _buildDrawerItem(Icons.article, "Donation Guidelines", () {
                  // Handle navigation to guidelines
                }),
              ],
            ),
          ),
          Column(
            children: [
              const Divider(),
              _buildDrawerItem(Icons.settings, "Setting", () {
                // Handle settings navigation
              }),
              _buildDrawerItem(Icons.logout, "Log Out", () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
