import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/profile.dart'; // DEĞİŞTİ

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class WasteScreen extends ConsumerStatefulWidget {
  @override
  _WasteScreenState createState() => _WasteScreenState();
}

class _WasteScreenState extends ConsumerState<WasteScreen> {
  int _bottomNavIndex = -1;

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  final List<Map<String, dynamic>> _tips = [
    {
      'icon': Icons.lightbulb_outline,
      'title': 'Store Herbs Properly',
      'description': 'Wrap fresh herbs in a damp paper towel and store in a sealed container. They\'ll last up to 2 weeks longer!',
      'category': 'Storage Tips',
      'color': Color(0xFF9DB67B),
    },
    {
      'icon': Icons.recycling,
      'title': 'Vegetable Scraps Broth',
      'description': 'Save onion peels, carrot tops, and celery ends in the freezer. When you have enough, make a delicious homemade vegetable broth!',
      'category': 'Zero Waste',
      'color': Color(0xFF7BA68D),
    },
    {
      'icon': Icons.eco,
      'title': 'Ripen Fruits Faster',
      'description': 'Put unripe fruits in a paper bag with a banana. The ethylene gas will speed up ripening naturally.',
      'category': 'Kitchen Hacks',
      'color': Color(0xFF8DB67B),
    },
  ];

  void _onNavigationTap(int index) {
    setState(() {
      _bottomNavIndex = index;
    });

    Widget page;
    switch (index) {
      case 0: page = HomeScreen(); break;
      case 1: page = SearchRecipeScreen(); break;
      case 2: page = FavoritesScreen(); break;
      case 3: page = ProfileScreen(); break; // DÜZELTİLDİ
      default: return;
    }

    if (index == 0) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
    }
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AiChefScreen()));
      },
      backgroundColor: primaryGreen,
      shape: const CircleBorder(),
      elevation: 4.0,
      child: Container(
        width: 50, height: 50, padding: EdgeInsets.all(2),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 25, rightCornerRadius: 25,
        backgroundColor: secondaryGreen,
        activeColor: primaryGreen,
        inactiveColor: primaryGreen.withOpacity(0.6),
        splashSpeedInMilliseconds: 300,
        notchMargin: 8,
        onTap: _onNavigationTap,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(24)),
                child: Center(child: Text('Yes taste, no waste!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                itemCount: _tips.length,
                itemBuilder: (context, index) {
                  final tip = _tips[index];
                  return _buildTipCard(
                    icon: tip['icon'],
                    title: tip['title'],
                    description: tip['description'],
                    category: tip['category'],
                    color: tip['color'],
                    isEven: index % 2 == 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({required IconData icon, required String title, required String description, required String category, required Color color, required bool isEven}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: lightGreen, shape: BoxShape.circle, border: Border.all(color: color.withOpacity(0.3), width: 2), boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8, offset: Offset(0, 4))]),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.85),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(12)), child: Text(category, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5))),
                  SizedBox(height: 10),
                  Text(title, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(description, style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 14, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}