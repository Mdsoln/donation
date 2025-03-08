import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center( // Centers the content
          child: SingleChildScrollView( // Ensures it’s scrollable on smaller screens
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Centers vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Aligns text in the center
              children: [
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/drop.jpeg',
                  width: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to Donor App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const InputField(hintText: "Full Name", labelText: 'Full Name', icon: Icons.person),
                const SizedBox(height: 16),
                const InputField(hintText: "example@gmail.com", labelText: 'Email', icon: Icons.email),
                const SizedBox(height: 16),
                const InputField(labelText: "Phone Number", icon: Icons.phone, hintText: '+255',),
                const SizedBox(height: 16),
                const InputField(hintText: "Password", isPassword: true, labelText: 'Password', icon: Icons.lock),
                const SizedBox(height: 16),
                const InputField(hintText: "Confirm Password", isPassword: true, labelText: 'Confirm Password', icon: Icons.lock),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Register",
                  onPressed: () {
                    // TODO: Implement registration API call
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Sign in",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
