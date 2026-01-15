import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/recipe.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/profile.dart';
import 'package:eco_kitchen/data/favorites_data.dart';

import '../auth/auth_gate.dart';
import '../backend/favorites_api.dart';
import '../backend/recipes_api.dart';
import '../backend/token_store.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class SearchRecipeScreen extends StatefulWidget {
  @override
  _SearchRecipeScreenState createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  int _bottomNavIndex = 1; // Search tab is active
  final RecipesApi _recipesApi = RecipesApi();
  final FavoritesApi _favoritesApi = FavoritesApi();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _isLoading = false;
  String? _errorMessage;
  List<RecipeCard> _featuredRecipes = [];
  List<RecipeCard> _allRecipes = [];
  List<RecipeCard> _filteredRecipes = [];

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search_sharp,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    _ensureAuthenticated();
    _loadRecipes();
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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    List<RecipeCard> featured = [];
    List<RecipeCard> all = [];
    String? errorMessage;

    try {
      featured = await _recipesApi.fetchRecipes(
        featured: true,
        limit: 20,
        offset: 0,
      );
    } catch (_) {
      errorMessage = 'Failed to load featured recipes.';
    }

    try {
      all = await _recipesApi.fetchRecipes(
        limit: 50,
        offset: 0,
      );
    } catch (_) {
      if (errorMessage == null) {
        errorMessage = 'Failed to load recipes.';
      }
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _featuredRecipes = featured;
      _allRecipes = all;
      _filteredRecipes = [];
      _errorMessage = errorMessage;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      setState(() {
        _filteredRecipes = [];
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final lowerQuery = trimmed.toLowerCase();
      final results = _allRecipes
          .where((recipe) => recipe.name.toLowerCase().contains(lowerQuery))
          .take(20)
          .toList();
      if (!mounted) {
        return;
      }
      setState(() {
        _filteredRecipes = results;
      });
    });
  }

  Future<void> _toggleFavorite({
    required int recipeId,
    required String title,
    required String image,
  }) async {
    final isFav = favoritesData.isFavorite(title);
    try {
      if (isFav) {
        await _favoritesApi.removeFavorite(recipeId);
        favoritesData.removeFavorite(title);
      } else {
        await _favoritesApi.addFavorite(recipeId);
        favoritesData.addFavorite({
          'id': recipeId,
          'title': title,
          'image': image,
        });
      }
      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update favorite. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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
    final hasSearchQuery = _searchController.text.trim().length >= 2;
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
                          controller: _searchController,
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
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else if (hasSearchQuery)
                _buildSearchResults()
              else ...[
                _buildSectionHeader('Featured'),
                SizedBox(height: 12),
                _buildFeaturedGrid(),
                SizedBox(height: 100),
              ],
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

  Widget _buildHorizontalRecipeList(List<RecipeCard> recipes) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _buildRecipeCard(
            recipeId: recipe.id,
            title: recipe.name,
            image: recipe.imageUrl.isNotEmpty
                ? recipe.imageUrl
                : 'assets/images/meal.png',
            isPro: recipe.isFeatured,
          );
        },
      ),
    );
  }

  Widget _buildFeaturedGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: _featuredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _featuredRecipes[index];
        return _buildRecipeCard(
          recipeId: recipe.id,
          title: recipe.name,
          image: recipe.imageUrl.isNotEmpty
              ? recipe.imageUrl
              : 'assets/images/meal.png',
          isPro: recipe.isFeatured,
        );
      },
    );
  }

  Widget _buildRecipeCard({
    required int recipeId,
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
            builder: (context) => RecipeScreen(
              recipeId: recipeId,
              title: title,
              image: image,
            ),
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
                    child: _buildRecipeImage(image),
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
                    onTap: () => _toggleFavorite(
                      recipeId: recipeId,
                      title: title,
                      image: image,
                    ),
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

  Widget _buildRecipeImage(String image) {
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      image,
      fit: BoxFit.cover,
    );
  }

  Widget _buildSearchResults() {
    if (_filteredRecipes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Center(
          child: Text(
            'No recipes found.',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _filteredRecipes[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(recipe.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeScreen(
                  recipeId: recipe.id,
                  title: recipe.name,
                  image: recipe.imageUrl.isNotEmpty
                      ? recipe.imageUrl
                      : 'assets/images/meal.png',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
