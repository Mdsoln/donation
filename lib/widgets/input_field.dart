import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final double borderRadius;
  final TextEditingController? controller; // Added controller

  const InputField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.borderRadius = 12.0,
    this.controller, // Added controller
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller, // Assign controller here
        obscureText: isPassword,
        style: const TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
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
