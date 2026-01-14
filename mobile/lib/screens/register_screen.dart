import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_kitchen/core/services/api_service.dart';
import 'package:eco_kitchen/backend/fastapi.dart';
import 'package:eco_kitchen/screens/verification.dart';

// Renk Tanımları (Eksik olan secondaryGreen eklendi)
const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

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

  // Şifre kuralları
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
        SnackBar(content: Text("Please meet all password requirements")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = ref.read(apiServiceProvider);
      final api = FastAPI(dio);

      await api.register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationScreen(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 32),

              // Name Input
              Text("Name", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              _buildTextField(controller: _nameController, hint: "Your name"),

              SizedBox(height: 16),

              // Email Input
              Text("Email", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              _buildTextField(controller: _emailController, hint: "example@email.com"),

              SizedBox(height: 16),

              // Password Input
              Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: "********",
                isPassword: true,
                onChanged: (_) => setState(() {}),
              ),

              SizedBox(height: 16),

              // Password Requirements
              _buildPasswordRequirement("Must be at least 8 characters", _hasMinLength),
              _buildPasswordRequirement("Must contain one number", _hasNumber),
              _buildPasswordRequirement("Must contain one letter", _hasLetter),

              SizedBox(height: 32),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Terms & Login Link
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "By signing up, you agree to our ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    children: [
                      TextSpan(
                        text: "Terms",
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ", "),
                      TextSpan(
                        text: "Data Policy",
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: " and "),
                      TextSpan(
                        text: "Cookies Policy",
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: "."),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryGreen.withOpacity(0.3), // Artık hata vermeyecek
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryGreen.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? primaryGreen : Colors.grey,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.black87 : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}