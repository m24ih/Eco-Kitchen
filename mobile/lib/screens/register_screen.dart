import 'package:dio/dio.dart';
import 'package:eco_kitchen/core/services/api_service.dart';
import 'package:eco_kitchen/screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_kitchen/core/providers/onboarding_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Password validation states
  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasLetter => _passwordController.text.contains(RegExp(r'[a-zA-Z]'));

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in the fields")),
      );
      return;
    }

    if (!_hasMinLength || !_hasNumber || !_hasLetter) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("It does not meet the password requirements.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // API çağrısı geçici olarak devre dışı - Backend entegrasyonu için
    // final onboardingData = ref.read(onboardingProvider);
    // final dio = ref.read(apiServiceProvider);

    // Geçici: Doğrudan verification ekranına git
    await Future.delayed(Duration(milliseconds: 500)); // Simüle loading

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Registration successful! Enter the verification code."),
          backgroundColor: Color(0xFF9DB67B),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              // Title
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Create account",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32),

              // Name Field
              Text(
                "Name",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter name",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF9DB67B), width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              SizedBox(height: 20),

              // Email Field
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "enter_mail@email.com",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF9DB67B), width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              SizedBox(height: 20),

              // Password Field
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "••••••",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF9DB67B), width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Password Requirements
              _buildPasswordRequirement("Minimum 8 characters", _hasMinLength),
              SizedBox(height: 8),
              _buildPasswordRequirement("Atleast 1 number (1-9)", _hasNumber),
              SizedBox(height: 8),
              _buildPasswordRequirement(
                  "Atleast lowercase or uppercase letters", _hasLetter),
              SizedBox(height: 32),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9DB67B),
                    disabledBackgroundColor: Color(0xFF9DB67B).withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24),

              // Sign In Link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Have an account? ",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign In",
                        style: TextStyle(
                          color: Color(0xFF9DB67B),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Terms and Data Policy
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "By clicking Register, you agree to our\n",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: "Terms",
                        style: TextStyle(
                          color: Color(0xFF9DB67B),
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(text: ", "),
                      TextSpan(
                        text: "Data Policy",
                        style: TextStyle(
                          color: Color(0xFF9DB67B),
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(text: "."),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check : Icons.close,
          size: 18,
          color: isMet ? Color(0xFF9DB67B) : Colors.red[400],
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
