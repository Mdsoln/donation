import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.center, // Aligns content horizontally
            mainAxisAlignment: MainAxisAlignment.start, // Aligns content at the top
            children: [
              const SizedBox(height: 25), // Add spacing from the top
              Image.asset(
                'assets/images/drop.jpeg',
                width: 80,
              ),
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
              const InputField(
                hintText: "Enter your email",
                labelText: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Continue",
                onPressed: () {
                  // TODO: Implement forgot password API call
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Cancel",
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontFamily: 'Ubuntu',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: () {
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
