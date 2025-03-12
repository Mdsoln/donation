import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';
import 'reset_confirmation_screen.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false; // Add loading state

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetEmail() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading
    });

    final Uri apiUrl = Uri.parse("https://your-api.com/auth/reset-password");

    try {
      final response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset link sent! Check your email.")),
        );

        // Navigate to ResetConfirmationScreen after success
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResetConfirmationScreen()),
        );
      } else {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody["message"] ?? "Something went wrong. Try again!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please check your connection.")),
      );
    }

    setState(() {
      _isLoading = false; // Hide loading after request completes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Image.asset('assets/images/drop.jpeg', width: 80),
              const SizedBox(height: 20),
              const Text(
                "Reset Password",
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
                "Enter your email, and we will send you a reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              InputField(
                hintText: "Enter your email",
                labelText: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 24),

              // Continue Button
              CustomButton(
                text: _isLoading ? "Sending..." : "Continue", // Change text during loading
                onPressed: _isLoading ? null : _sendResetEmail, // Disable when loading
                isLoading: _isLoading, // Pass loading state to the button
              ),

              const SizedBox(height: 24),

              // Cancel Button
              CustomButton(
                text: "Cancel",
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontFamily: 'Ubuntu',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: _isLoading ? null : () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
