import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod
import 'package:eco_kitchen/screens/sign_in.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class NewPasswordScreen extends ConsumerStatefulWidget {
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in both password fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 8 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Backend API Şifre Değiştirme
      // await api.changePassword(_newPasswordController.text);

      await Future.delayed(Duration(seconds: 1)); // Simülasyon

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: primaryGreen,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error changing password')),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                ),
                SizedBox(height: 32),
                Text('New Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 12),
                Text('Create your new password.', style: TextStyle(fontSize: 15, color: Colors.grey[500], height: 1.4)),
                SizedBox(height: 32),

                // New Password Input
                Text('New Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: secondaryGreen.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryGreen.withOpacity(0.5)),
                  ),
                  child: TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      hintText: 'Your password',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                        child: Icon(_obscureNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[500]),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Confirm Password Input
                Text('Confirm Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: secondaryGreen.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryGreen.withOpacity(0.5)),
                  ),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Your password',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        child: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[500]),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Send Button
                GestureDetector(
                  onTap: _isLoading ? null : _onSend,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(28)),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Send', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}