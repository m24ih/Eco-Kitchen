import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Şevval YILDIZ');
  final TextEditingController _emailController =
      TextEditingController(text: 'yildiz2.kar@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '••••••••');
  bool _obscurePassword = true;
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Information updated!'),
        backgroundColor: primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'My Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_isEditing) {
                _saveChanges();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
            child: Text(
              _isEditing ? 'Save' : 'Edit',
              style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: secondaryGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: primaryGreen,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // Name field
            _buildLabel('Name'),
            SizedBox(height: 8),
            _buildTextField(
              controller: _nameController,
              enabled: _isEditing,
              icon: Icons.person_outline,
            ),

            SizedBox(height: 24),

            // Email field
            _buildLabel('Email'),
            SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              enabled: _isEditing,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 24),

            // Password field
            _buildLabel('Password'),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _isEditing ? Colors.white : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isEditing ? primaryGreen : Colors.grey[300]!,
                ),
              ),
              child: TextField(
                controller: _passwordController,
                enabled: _isEditing,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: _isEditing ? primaryGreen : Colors.grey[500],
                  ),
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
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            SizedBox(height: 40),

            // Delete account button
            Center(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Account'),
                      content: Text(
                          'Are you sure you want to delete your account? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Implement account deletion
                          },
                          child: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required bool enabled,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? primaryGreen : Colors.grey[300]!,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: enabled ? primaryGreen : Colors.grey[500],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
