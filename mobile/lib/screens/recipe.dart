import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/recipe_reviews.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/data/favorites_data.dart';

import '../auth/auth_gate.dart';
import '../backend/token_store.dart';
import '../backend/recipes_api.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class RecipeScreen extends StatefulWidget {
  final String title;
  final String image;
  final int recipeId;

  const RecipeScreen({
    Key? key,
    required this.title,
    required this.image,
    required this.recipeId,
  }) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _bottomNavIndex = 0;
  int _selectedTab = 0; // 0: Cookware, 1: Ingredients, 2: Instructions
  final RecipesApi _recipesApi = RecipesApi();
  bool _isLoading = true;
  String? _errorMessage;
  RecipeDetail? _detail;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    _ensureAuthenticated();
    _loadRecipe();
  }

  Future<void> _ensureAuthenticated() async {
    final token = await TokenStore().getToken();
    if (!mounted) {
      return;
    }
    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    }
  }

  Future<void> _loadRecipe() async {
    if (widget.recipeId <= 0) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Recipe unavailable.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detail = await _recipesApi.fetchRecipeDetail(widget.recipeId);
      if (!mounted) {
        return;
      }
      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = "Failed to load recipe.";
        _isLoading = false;
      });
    }
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
    final title = _detail?.card.name.isNotEmpty == true
        ? _detail!.card.name
        : widget.title;
    bool isFav = favoritesData.isFavorite(title);

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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : SingleChildScrollView(
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
                                        recipeTitle: title,
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
                                child: _buildRecipeImage(),
                              ),
                              // Favorite button on image
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      favoritesData.toggleFavorite({
                                        'title': title,
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
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFav
                                          ? Colors.red[400]
                                          : Colors.grey[400],
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
                              Expanded(
                                  child: _buildTabButton('Instructions', 2)),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Tab content
                        if (_selectedTab == 0) _buildCookwareTab(isFav, title),
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

  Widget _buildCookwareTab(bool isFav, String title) {
    final detail = _detail;
    final servings = detail?.card.servings;
    final prep = detail?.card.prepTimeMinutes;
    final cook = detail?.card.cookTimeMinutes;
    final timeLabel = _buildTimeLabel(prep, cook);
    final servingsLabel =
        servings != null && servings > 0 ? '$servings servings' : '';
    final nutrition = _detail?.card;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe title
          Text(
            title.length > 50
                ? title
                : title.isNotEmpty
                    ? title
                    : 'Recipe',
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
            [timeLabel, servingsLabel].where((item) => item.isNotEmpty).join(' • '),
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
                      _formatNutrition(nutrition?.carbsG, 'g carbs'))),
              SizedBox(width: 16),
              Expanded(
                  child: _buildNutritionCard(FontAwesomeIcons.bacon,
                      _formatNutrition(nutrition?.proteinG, 'g proteins'))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildNutritionCard(
                      FontAwesomeIcons.fire,
                      _formatCalories(nutrition?.caloriesKcal))),
              SizedBox(width: 16),
              Expanded(
                  child: _buildNutritionCard(FontAwesomeIcons.pizzaSlice,
                      _formatNutrition(nutrition?.fatG, 'g fats'))),
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
    final ingredients = _detail?.ingredients ?? [];
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
                  ingredient.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _formatIngredientAmount(ingredient),
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
    final instructions = _detail?.steps ?? [];
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
                  '${instruction.stepNumber}',
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
                        instruction.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      if (instruction.ingredients.isNotEmpty) ...[
                        SizedBox(height: 12),
                        ...instruction.ingredients.map((ing) {
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
                        }),
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

  Widget _buildRecipeImage() {
    final imageUrl = _detail?.card.imageUrl ?? '';
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      widget.image,
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  String _formatIngredientAmount(RecipeIngredient ingredient) {
    if (ingredient.amountText.isNotEmpty) {
      return ingredient.amountText;
    }
    if (ingredient.quantity != null && ingredient.unit.isNotEmpty) {
      return '${ingredient.quantity} ${ingredient.unit}';
    }
    return ingredient.unit.isNotEmpty ? ingredient.unit : '-';
  }

  String _buildTimeLabel(int? prepMinutes, int? cookMinutes) {
    final parts = <String>[];
    if (prepMinutes != null && prepMinutes > 0) {
      parts.add('$prepMinutes min prep');
    }
    if (cookMinutes != null && cookMinutes > 0) {
      parts.add('$cookMinutes min cook');
    }
    return parts.isEmpty ? '' : parts.join(' • ');
  }

  String _formatNutrition(double? value, String suffix) {
    if (value == null) {
      return '-';
    }
    final formatted = value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
    return '$formatted $suffix';
  }

  String _formatCalories(int? value) {
    if (value == null) {
      return '-';
    }
    return '$value Kcal';
  }
}
