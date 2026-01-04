import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/account.dart';
import 'package:eco_kitchen/screens/onboarding1.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _bottomNavIndex = 3; // Profile is selected

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person,
  ];

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AiChefScreen()),
        );
      },
      backgroundColor: primaryGreen,
      shape: const CircleBorder(),
      elevation: 4.0,
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
                (route) => false,
              );
            },
            child: Text('Log Out', style: TextStyle(color: primaryGreen)),
          ),
        ],
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Your Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 25,
        rightCornerRadius: 25,
        backgroundColor: secondaryGreen,
        activeColor: primaryGreen,
        inactiveColor: primaryGreen.withOpacity(0.6),
        splashSpeedInMilliseconds: 300,
        notchMargin: 8,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchRecipeScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          } else {
            setState(() => _bottomNavIndex = index);
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    secondaryGreen.withOpacity(0.5),
                    secondaryGreen.withOpacity(0.3),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Şevval YILDIZ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'yildiz2.kar@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Logout button
                  GestureDetector(
                    onTap: _logout,
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Menu items
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'My Account',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.chat_bubble_outline,
              title: 'Language',
              onTap: () {
                // TODO: Navigate to language settings
              },
            ),

            // Yasal section
            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'Legal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryGreen,
                ),
              ),
            ),

            _buildMenuItem(
              icon: Icons.shield_outlined,
              title: 'Privacy Policy',
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: 'Terms of Use',
              onTap: () {
                // TODO: Navigate to terms
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'Data Protection Notice',
              onTap: () {
                // TODO: Navigate to KVKK
              },
            ),

            SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.black87,
                size: 22,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
