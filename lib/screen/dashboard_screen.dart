import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.red,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'), // User profile pic
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Blood Group: A+", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Donations: 0", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Sample list of donation requests
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("John Doe"),
                      subtitle: Text("Needs Blood: O+"),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text("Donate"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
