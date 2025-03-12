import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/register_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
      final TextEditingController fullNameController = TextEditingController();
      final TextEditingController emailController = TextEditingController();
      final TextEditingController phoneController = TextEditingController();
      final TextEditingController passwordController = TextEditingController();
      final TextEditingController confirmPasswordController = TextEditingController();
      final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      bool isLoading = false;

      String? _validateFullName(String? value) {
        if (value == null || value.trim().isEmpty) return "Full name is required";
        return null;
      }

      String? _validateEmail(String? value) {
        if (value == null || value.trim().isEmpty) return "Email is required";
        final emailRegex = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
        if (!emailRegex.hasMatch(value)) return "Enter a valid email";
        return null;
      }

      String? _validatePhone(String? value) {
        if (value == null || value.trim().isEmpty) return "Phone number is required";
        final phoneRegex = RegExp(r"^\+\d{10,15}$");
        if (!phoneRegex.hasMatch(value)) return "Enter a valid phone number";
        return null;
      }

      String? _validatePassword(String? value) {
        if (value == null || value.trim().isEmpty) return "Password is required";
        if (value.length < 6) return "Password must be at least 6 characters";
        return null;
      }

      String? _validateConfirmPassword(String? value) {
        if (value != passwordController.text) return "Passwords do not match";
        return null;
      }

      void _register() async {
        if (!_formKey.currentState!.validate()) return;

        setState(() => isLoading = true);

        try {
          final apiService = RegisterService();
          await apiService.registerDonor(
            fullName: fullNameController.text,
            email: emailController.text,
            phone: phoneController.text,
            password: passwordController.text,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registered Successfully")),
          );

          Navigator.pop(context);
        } catch (e) {
          String errorMessage = "Something went wrong. Please try again.";
          if (e is http.Response){
              if (e.statusCode == 409) {
                errorMessage = "Email already exists. Please use a different email.";
              }else if (e.statusCode == 400) {
                errorMessage = "Invalid request. Please check your input.";
              }else if (e.statusCode == 500) {
                errorMessage = "Server error. Please try again later.";
              } else {
                errorMessage = "An error occurred. Status code: ${e.statusCode}";
              }
          } else if (e is SocketException) {
            errorMessage = "No internet connection. Please check your network.";
          } else if (e is TimeoutException) {
            errorMessage = "Request timed out. Please try again.";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        } finally {
          setState(() => isLoading = false);
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/drop.jpeg', width: 80),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to Donor App",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text("Create your account", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 24),

                      InputField(
                        controller: fullNameController,
                        hintText: "Full Name",
                        labelText: 'Full Name',
                        icon: Icons.person,
                        validator: _validateFullName,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: emailController,
                        hintText: "example@gmail.com",
                        labelText: 'Email',
                        icon: Icons.email,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: phoneController,
                        hintText: "+255",
                        labelText: "Phone Number",
                        icon: Icons.phone,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: passwordController,
                        hintText: "Password",
                        isPassword: true,
                        labelText: 'Password',
                        icon: Icons.lock,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        isPassword: true,
                        labelText: 'Confirm Password',
                        icon: Icons.lock,
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 24),

                      isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(text: "Register", onPressed: _register),

                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text("Already have an account? Sign in", style: TextStyle(fontFamily: 'Ubuntu', color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
}
