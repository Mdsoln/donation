import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);

    try {
      AuthRequest request = AuthRequest(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      AuthResponse response = await _authService.login(request);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      await prefs.setString('username', response.username);
      await prefs.setString('roles', response.roles);
      await prefs.setString('email', response.email);
      await prefs.setString('phone', response.phone);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } catch (e) {
      String errorMessage = "Something went wrong. Please try again.";
      if (e is http.Response) {
        if (e.statusCode == 401) {
          errorMessage = "Wrong username or password";
        } else if (e.statusCode == 500) {
          errorMessage = "Server error. Please try again later.";
        }
      } else if (e is SocketException) {
        errorMessage = "No internet connection. Please check your network.";
      } else if (e is TimeoutException) {
        errorMessage = "Request timed out. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/drop.jpeg', width: 80),
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
                "Log in to your account and save a life.",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              InputField(controller: _emailController, hintText: "Email", labelText: 'Email', icon: Icons.email),
              const SizedBox(height: 16),
              InputField(controller: _passwordController, hintText: "Password", isPassword: true, labelText: 'Password', icon: Icons.lock),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                  ),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isLoading ? "Logging in..." : "Log in",
                onPressed: _isLoading ? null : _login,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                ),
                child: const Text(
                  "New user? Sign up",
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
    );
  }
}
