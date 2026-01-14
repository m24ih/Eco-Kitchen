import 'package:dio/dio.dart';
import 'package:eco_kitchen/backend/fastapi.dart';
import 'package:eco_kitchen/core/services/api_service.dart';
import 'package:eco_kitchen/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class AccountScreen extends ConsumerStatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(text: '••••••••');

  bool _obscurePassword = true;
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final dio = ref.read(apiServiceProvider);
      final api = FastAPI(dio);
      final userData = await api.getUserProfile();

      if (mounted) {
        setState(() {
          _emailController.text = userData['email'] ?? '';
          _nameController.text = userData['full_name'] ?? 'User';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not load user data")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: primaryGreen)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Geri Butonu -> ProfileScreen'e döner
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'My Account',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_isEditing) {
                // Save logic here
                setState(() => _isEditing = false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated!'), backgroundColor: primaryGreen));
              } else {
                setState(() => _isEditing = true);
              }
            },
            child: Text(
              _isEditing ? 'Save' : 'Edit',
              style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar YOK - Burası bir detay sayfası
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                  child: Icon(Icons.person, color: Colors.white, size: 50),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(color: secondaryGreen, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      child: Icon(Icons.camera_alt, color: primaryGreen, size: 16),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 40),

            _buildLabel('Name'),
            SizedBox(height: 8),
            _buildTextField(controller: _nameController, enabled: _isEditing, icon: Icons.person_outline),

            SizedBox(height: 24),

            _buildLabel('Email'),
            SizedBox(height: 8),
            _buildTextField(controller: _emailController, enabled: false, icon: Icons.email_outlined),

            SizedBox(height: 24),

            _buildLabel('Password'),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _isEditing ? Colors.white : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isEditing ? primaryGreen : Colors.grey[300]!),
              ),
              child: TextField(
                controller: _passwordController,
                enabled: _isEditing,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: _isEditing ? primaryGreen : Colors.grey[500]),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[500]),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            SizedBox(height: 40),

            TextButton(
              onPressed: () {},
              child: Text('Delete Account', style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)));

  Widget _buildTextField({required TextEditingController controller, required bool enabled, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: enabled ? primaryGreen : Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: enabled ? primaryGreen : Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}