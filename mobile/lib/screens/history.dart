import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/recipe.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Sample history data
  List<Map<String, String>> _historyItems = [
    {
      'title': 'Easy homemade beef burger',
      'image': 'assets/images/meal.png',
    },
    {
      'title': 'Easy homemade beef burger',
      'image': 'assets/images/meal.png',
    },
  ];

  void _deleteItem(int index) {
    setState(() {
      _historyItems.removeAt(index);
    });
  }

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
        leftCornerRadius: 25,
        rightCornerRadius: 25,
        backgroundColor: secondaryGreen,
        activeColor: primaryGreen,
        inactiveColor: primaryGreen.withOpacity(0.6),
        splashSpeedInMilliseconds: 300,
        notchMargin: 8,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ),

            SizedBox(height: 16),

            // History list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _historyItems.length,
                itemBuilder: (context, index) {
                  return _buildHistoryCard(_historyItems[index], index);
                },
              ),
            ),

            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, String> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryGreen, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Recipe image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item['image']!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                item['title']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            // Action buttons
            Column(
              children: [
                // Delete button
                GestureDetector(
                  onTap: () => _deleteItem(index),
                  child: Icon(
                    Icons.delete_outline,
                    color: primaryGreen,
                    size: 24,
                  ),
                ),
                SizedBox(height: 20),
                // Arrow button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeScreen(
                          title: item['title']!,
                          image: item['image']!,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: primaryGreen,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
