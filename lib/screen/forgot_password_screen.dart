import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/drop.jpeg',
                width: 80,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Reset Password",
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
              style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const InputField(hintText: "Enter your email", labelText: 'Email', icon: Icons.email,),
            const SizedBox(height: 24),
            CustomButton(
              text: "Continue",
              onPressed: () {
                // TODO: Implementing forget password api call
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
