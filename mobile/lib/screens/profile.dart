import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/account.dart'; // Detay sayfasına gidecek
import 'package:eco_kitchen/screens/onboarding1.dart';
import 'package:eco_kitchen/backend/fastapi.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _bottomNavIndex = 3; // Burası 4. sekme

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person,
  ];

  // --- NAVİGASYON ---
  void _onNavigationTap(int index) {
    if (index == _bottomNavIndex) return;

    setState(() {
      _bottomNavIndex = index;
    });

    Widget page;
    switch (index) {
      case 0: page = HomeScreen(); break;
      case 1: page = SearchRecipeScreen(); break;
      case 2: page = FavoritesScreen(); break;
      case 3: return; // Zaten buradayız
      default: return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _logout() async {
    // Logout onayı ve işlemi
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
            onPressed: () async {
              Navigator.pop(context);
              await FastAPI.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
                    (route) => false,
              );
            },
            child: Text('Log Out', style: TextStyle(color: Colors.red)),
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
        automaticallyImplyLeading: false, // Geri butonu yok, burası ana sayfa
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AiChefScreen())),
        backgroundColor: primaryGreen,
        child: Icon(Icons.eco, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: _onNavigationTap,
        activeColor: primaryGreen,
        inactiveColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),

            // --- MENÜLER ---

            // 1. My Account (Detay Sayfasına Gider)
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'My Account',
              onTap: () {
                // Burada push kullanıyoruz ki geri dönülebilsin
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.language,
              title: 'Language',
              onTap: () {},
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Legal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryGreen)),
              ),
            ),

            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {},
            ),

            _buildMenuItem(
              icon: Icons.logout,
              title: 'Log Out',
              onTap: _logout,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap, bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? Colors.red : primaryGreen, size: 24),
            SizedBox(width: 16),
            Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDestructive ? Colors.red : Colors.black87))),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}