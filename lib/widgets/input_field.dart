import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final double borderRadius;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.borderRadius = 12.0,
    this.controller,
    this.validator,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword,
            style: const TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 16,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              errorText: errorMessage,
            ),
            validator: widget.validator,
            onChanged: (value) {
              setState(() {
                errorMessage = widget.validator?.call(value);
              });
            },
          ),
          if (errorMessage != null) // Show error message if present
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
