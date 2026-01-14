import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Sayfa importları
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/recipe.dart';
import 'package:eco_kitchen/screens/profile.dart'; // DEĞİŞTİ: account.dart -> profile.dart

const Color primaryGreen = Color(0xFF9DB67B);

class AiChefScreen extends ConsumerStatefulWidget {
  @override
  _AiChefScreenState createState() => _AiChefScreenState();
}

class _AiChefScreenState extends ConsumerState<AiChefScreen> {
  int _bottomNavIndex = -1;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Chicken Curry',
      'image': 'assets/images/meal.png',
      'time': '45 min',
      'rating': 5,
      'servings': '2,458',
    },
    {
      'title': 'Vegetable Stir Fry',
      'image': 'assets/images/meal.png',
      'time': '20 min',
      'rating': 4,
      'servings': '1,200',
    },
  ];

  void _onNavigationTap(int index) {
    setState(() {
      _bottomNavIndex = index;
    });

    Widget page;
    switch (index) {
      case 0:
        page = HomeScreen();
        break;
      case 1:
        page = SearchRecipeScreen();
        break;
      case 2:
        page = FavoritesScreen();
        break;
      case 3:
        page = ProfileScreen(); // DÜZELTİLDİ: ProfileScreen'e gidiyor
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
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
        title: Text(
          'AI Chef',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Yapay zeka tarif üretiyor... (Yakında)")),
          );
        },
        backgroundColor: primaryGreen,
        child: Icon(Icons.eco, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: _onNavigationTap,
        activeColor: primaryGreen,
        inactiveColor: Colors.grey,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What can I cook with these?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Based on your inventory",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeScreen(
                            title: recipe['title'],
                            image: recipe['image'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              recipe['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      recipe['time'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 16),
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      "${recipe['rating']}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}