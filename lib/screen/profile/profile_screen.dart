import 'package:donor_app/screen/profile/service/update_profile_service.dart';
import 'package:flutter/material.dart';
import '../auth/models/auth_model.dart';
import 'EditProfileScreen.dart';
import 'dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AuthResponse user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthResponse user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  Future<void> _refreshProfile() async {
    setState(() {});
  }

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    user: user,
                    onSave: (request) async {
                      try{
                        final updateProfileAPI = UpdateProfile();
                        await updateProfileAPI.updateProfile(request);
                        await _refreshProfile();
                      }catch(e) {
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
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
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
            const SizedBox(height: 8),
            Text(
              user.username,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user.lastDonation,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _InfoCard(title: "Donations", value: "${user.donations}"),
                _InfoCard(title: "Request", value: "03"),
                _InfoCard(title: "Appointments", value: "01"),
              ],
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gender Section
                  _IconWithLabelRow(
                    icon: Icons.female,
                    label: "Gender",
                    value: user.gender,
                    iconColor: Colors.pink,
                  ),
                  // Blood Group Section
                  _IconWithLabelRow(
                    icon: Icons.bloodtype,
                    label: "Blood Group",
                    value: user.bloodGroup,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const _DetailTile(icon: Icons.location_on, title: "Location", value: "Mawasiliano"),
                  _DetailTile(icon: Icons.calendar_today, title: "Date of Birth", value: user.dateOfBirth),
                  _DetailTile(icon: Icons.phone, title: "Phone Number", value: user.mobile),
                  _DetailTile(icon: Icons.email, title: "Email Address", value: user.email),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Height Section
                  _IconWithLabelRow(
                    icon: Icons.height,
                    label: "Height",
                    value: "${user.height} cm",
                    iconColor: Colors.redAccent,
                  ),
                  // Weight Section
                  _IconWithLabelRow(
                    icon: Icons.fitness_center,
                    label: "Weight",
                    value: "${user.weight} kg",
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
              MaterialPageRoute(builder: (context) => ProfileScreen(user: user,)),
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