import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/recipe.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/profile.dart';
import 'package:eco_kitchen/data/favorites_data.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class SearchRecipeScreen extends StatefulWidget {
  @override
  _SearchRecipeScreenState createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  int _bottomNavIndex = 1; // Search tab is active

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search_sharp,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Most Popular recipes
  final List<Map<String, dynamic>> _mostPopular = [
    {
      'title': 'Brussels Sprouts, Mashed Potato & Sausage Bowl with...',
      'image': 'assets/images/meal.png',
      'isPro': true,
    },
    {
      'title':
          'Roasted Cauliflower & Black Bean Burrito Bowl with Cilantro Li...',
      'image': 'assets/images/meal.png',
      'isPro': false,
    },
    {
      'title': 'Creamy Cashew Zucchini Noodles with Vegan...',
      'image': 'assets/images/meal.png',
      'isPro': false,
    },
    {
      'title': 'Honey Glazed Salmon with Asparagus',
      'image': 'assets/images/meal.png',
      'isPro': true,
    },
  ];

  // Recently Created recipes
  final List<Map<String, dynamic>> _recentlyCreated = [
    {
      'title': 'Indian Butter Chicken with Basmati Rice (Chicken Makhan...',
      'image': 'assets/images/meal.png',
      'isPro': false,
    },
    {
      'title':
          'Greek Salad with Feta Cheese & Kalamata Olives (Greek Deligh...',
      'image': 'assets/images/meal.png',
      'isPro': true,
    },
    {
      'title': 'Italian Pasta with Tomato & Basil (Pomodoro)...',
      'image': 'assets/images/meal.png',
      'isPro': false,
    },
    {
      'title': 'Thai Green Curry with Coconut Rice',
      'image': 'assets/images/meal.png',
      'isPro': false,
    },
  ];

  void _toggleFavorite(Map<String, dynamic> recipe) {
    setState(() {
      favoritesData.toggleFavorite(recipe);
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
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          } else {
            setState(() => _bottomNavIndex = index);
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search recipe',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          cursorColor: Colors.white,
                        ),
                      ),
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
              ),

              // Most Popular section
              _buildSectionHeader('Most Popular'),
              SizedBox(height: 12),
              _buildHorizontalRecipeList(_mostPopular),

              SizedBox(height: 24),

              // Recently Created section
              _buildSectionHeader('Recently Created'),
              SizedBox(height: 12),
              _buildHorizontalRecipeList(_recentlyCreated),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'See All',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalRecipeList(List<Map<String, dynamic>> recipes) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _buildRecipeCard(
            title: recipe['title'],
            image: recipe['image'],
            isPro: recipe['isPro'] ?? false,
          );
        },
      ),
    );
  }

  Widget _buildRecipeCard({
    required String title,
    required String image,
    required bool isPro,
  }) {
    bool isFav = favoritesData.isFavorite(title);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(title: title, image: image),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button and Pro badge
            Stack(
              children: [
                // Recipe image
                Container(
                  height: 140,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Pro badge
                if (isPro)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Pro',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[800],
                        ),
                      ),
                    ),
                  ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () =>
                        _toggleFavorite({'title': title, 'image': image}),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red[400] : Colors.grey[400],
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Recipe title
            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
