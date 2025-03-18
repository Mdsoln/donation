import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔴 Custom App Bar and Profile Section
            Container(
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
                  // 🔴 Custom App Bar
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {},
                      ),
                      const Spacer(), // Pushes the title to the end (if needed)
                    ],
                  ),
                  const SizedBox(height: 10), // Spacing between app bar and profile section

                  // 🔴 Profile Section
                  Row(
                    mainAxisSize: MainAxisSize.min, // Ensure the Row only takes up the space it needs
                    children: [
                      // 🔴 Left Side: Profile Circle, Name, and Location
                      Expanded(
                        flex: 1, // Give more space to the left side
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Circle and Name
                            Row(
                              children: [
                                // Profile Circle
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage("assets/profile.jpg"),
                                ),
                                const SizedBox(width: 10),
                                // Name
                                Flexible(
                                  child: Text(
                                    "Mdsoln",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Handle overflow
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10), // Spacing between Name and Location
                            // Location (Static)
                            Padding(
                              padding: const EdgeInsets.only(left: 2), // Align with the profile circle
                              child: Text(
                                "Mawasiliano, Dar es salaam",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis, // Handle overflow
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10), // Spacing between left and right content

                      // 🔴 Right Side: Blood Group and Donation Times with Vertical Lines
                      Expanded(
                        flex: 1, // Give more space to the right side
                        child: Row(
                          children: [
                            // Blood Group
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Vertical Line
                                  Container(
                                    width: 2,
                                    height: 55,
                                    color: Colors.white.withOpacity(0.5),
                                    margin: const EdgeInsets.only(right: 10),
                                  ),
                                  // Blood Group Text
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
                                        "A+",
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
                            const SizedBox(width: 4), // Spacing between Blood Group and Donation Times
                            // Donation Times
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Vertical Line
                                  Container(
                                    width: 2,
                                    height: 55, // Adjust height to match the content
                                    color: Colors.white.withOpacity(0.5),
                                    margin: const EdgeInsets.only(right: 10),
                                  ),
                                  // Donation Times Text
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
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "8", // Dynamic donation times
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
            ),

            // 🔴 Upcoming Appointment Card
            Padding(
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
                    // 🔴 Titles: "Upcoming Appointment" and "Attending Location"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded( // Left side (Appointment)
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
                              _countdownBox("1"),
                            ],
                          ),
                        ),
                        Expanded( // Right side (Location)
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
                              Row(
                                children: [
                                  Expanded( // Prevents text overflow
                                    child: Text(
                                      "Dar Es Salaam Blood Bank\n123 Main Street, Dar Es Salaam, Tanzania",
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "March 10, 2025\nTime: 10:00 AM",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
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

                    // 🟣 "Day to go" + "View" Button
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
                          onPressed: () {},
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
            ),

            // 🔴 Quick Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _actionButton("Find Donation Center", Icons.location_on),
                  _actionButton("Urgent Request", Icons.lock),
                  _actionButton("Schedule Appointment", Icons.calendar_month),
                  _actionButton("My Donation", Icons.favorite),
                ],
              ),
            ),

            // 🔴 Blood Donation Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/blood_donation.jpg", fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),

      // 🔴 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red.shade700,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  // 🔹 Helper Widget: Info Badge
  Widget _infoBadge(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  // 🔹 Helper Widget: Countdown Box
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

  // 🔹 Helper Widget: Action Buttons
  Widget _actionButton(String label, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red.shade700,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
      ),
      onPressed: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }
}