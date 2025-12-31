import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/recipe_reviews.dart';
import 'package:eco_kitchen/data/favorites_data.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class RecipeScreen extends StatefulWidget {
  final String title;
  final String image;

  const RecipeScreen({
    Key? key,
    required this.title,
    required this.image,
  }) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _bottomNavIndex = 0;
  int _selectedTab = 0; // 0: Cookware, 1: Ingredients, 2: Instructions

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Recipe data
  final Map<String, dynamic> _recipeData = {
    'time': '35 minutes',
    'servings': '2 servings',
    'nutrition': {
      'carbs': '65g carbs',
      'proteins': '27g proteins',
      'kcal': '120 Kcal',
      'fats': '91g fats',
    },
    'ingredients': [
      {'name': 'basmati rice', 'quantity': '½ cup'},
      {'name': 'chicken or vegetable broth', 'quantity': '16 fl oz'},
      {'name': 'cilantro', 'quantity': '½ small bunch'},
      {'name': 'coconut milk', 'quantity': '½ (13.5 fl oz) can'},
      {'name': 'garlic', 'quantity': '1 (1 inch) piece'},
      {'name': 'red lentils', 'quantity': '1 cup'},
      {'name': 'tomatoes', 'quantity': '2 medium'},
      {'name': 'curry powder', 'quantity': '2 tbsp'},
    ],
    'instructions': [
      {
        'step': 1,
        'text':
            'Using a strainer or colander, rinse the rice under cold, running water, then drain and transfer to a small saucepan. Add broth and bring the mixture to a boil over high heat.',
        'ingredients': [
          '½ cup basmati rice',
          '8 fl oz (1 cup) chicken or vegetable broth'
        ],
      },
      {
        'step': 2,
        'text':
            'Once boiling, reduce heat to low, cover, and simmer until rice is tender and liquid is absorbed, about 15-18 minutes.',
        'ingredients': [],
      },
      {
        'step': 3,
        'text':
            'Meanwhile, heat oil in a large skillet over medium heat. Add garlic and cook until fragrant, about 1 minute.',
        'ingredients': ['1 tbsp olive oil', '2 cloves garlic, minced'],
      },
      {
        'step': 4,
        'text':
            'Add lentils, remaining broth, coconut milk, and curry powder. Bring to a simmer and cook until lentils are tender, about 20 minutes.',
        'ingredients': [
          '1 cup red lentils',
          '½ can coconut milk',
          '2 tbsp curry powder'
        ],
      },
      {
        'step': 5,
        'text':
            'Stir in tomatoes and cilantro. Season with salt and pepper to taste. Serve over rice.',
        'ingredients': [
          '2 medium tomatoes, diced',
          '½ bunch cilantro, chopped'
        ],
      },
    ],
  };

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {},
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
    bool isFav = favoritesData.isFavorite(widget.title);

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
              // Header with back button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: primaryGreen,
                          size: 28,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeReviewsScreen(
                              recipeTitle: widget.title,
                              recipeImage: widget.image,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recipe image with favorite button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.image,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Favorite button on image
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            favoritesData.toggleFavorite({
                              'title': widget.title,
                              'image': widget.image,
                            });
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red[400] : Colors.grey[400],
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(child: _buildTabButton('Cookware', 0)),
                    SizedBox(width: 8),
                    Expanded(child: _buildTabButton('Ingredients', 1)),
                    SizedBox(width: 8),
                    Expanded(child: _buildTabButton('Instructions', 2)),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Tab content
              if (_selectedTab == 0) _buildCookwareTab(isFav),
              if (_selectedTab == 1) _buildIngredientsTab(),
              if (_selectedTab == 2) _buildInstructionsTab(),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[100] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.orange[300]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.orange[800] : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCookwareTab(bool isFav) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe title
          Text(
            widget.title.length > 50
                ? widget.title
                : 'Coconut Curry Red Lentil Dahl with Tomatoes, Cilantro & Rice.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
          ),

          SizedBox(height: 8),

          // Time and servings
          Text(
            '${_recipeData['time']} • ${_recipeData['servings']}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 24),

          // Nutrition info grid
          Row(
            children: [
              Expanded(
                  child: _buildNutritionCard(FontAwesomeIcons.wheatAwn,
                      _recipeData['nutrition']['carbs'])),
              SizedBox(width: 16),
              Expanded(
                  child: _buildNutritionCard(FontAwesomeIcons.bacon,
                      _recipeData['nutrition']['proteins'])),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildNutritionCard(
                      FontAwesomeIcons.fire, _recipeData['nutrition']['kcal'])),
              SizedBox(width: 16),
              Expanded(
                  child: _buildNutritionCard(FontAwesomeIcons.pizzaSlice,
                      _recipeData['nutrition']['fats'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: secondaryGreen.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: primaryGreen, size: 20),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    final ingredients = _recipeData['ingredients'] as List;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: ingredients.map((ingredient) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ingredient['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  ingredient['quantity'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInstructionsTab() {
    final instructions = _recipeData['instructions'] as List;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: instructions.map((instruction) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step number
                Text(
                  '${instruction['step']}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
                SizedBox(width: 16),
                // Step content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instruction['text'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      if ((instruction['ingredients'] as List).isNotEmpty) ...[
                        SizedBox(height: 12),
                        ...((instruction['ingredients'] as List).map((ing) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              ing,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        })),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
