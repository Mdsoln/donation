import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_field.dart';
import '../../profile/screen/dashboard_screen.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
          child: Form(
            key: _formKey,
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
                InputField(
                  controller: _emailController,
                  hintText: "Email",
                  labelText: 'Email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InputField(
                  controller: _passwordController,
                  hintText: "Password",
                  isPassword: true,
                  labelText: 'Password',
                  icon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
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
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: authProvider.isLoading ? "Logging in..." : "Log in",
                      onPressed: authProvider.isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await authProvider.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            // Only navigate if the widget is still mounted
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                                    (route) => false,
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              _showErrorSnackBar(e.toString());
                            }
                          }
                        }
                      },
                    );
                  },
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
      ),
    );
  }
}