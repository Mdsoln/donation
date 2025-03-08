import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? icon; // Icon is now nullable
  final bool isPassword;
  final double borderRadius;

  const InputField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.icon, // Nullable icon
    this.isPassword = false,
    this.borderRadius = 12.0, // Customizable border radius
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(
          fontFamily: 'Ubuntu', // Apply Ubuntu font to input text
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon) : null, // Handle nullable icon
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Customizable radius
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
}
