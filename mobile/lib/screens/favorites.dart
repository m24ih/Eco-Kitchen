import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/recipe.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/profile.dart';
import 'package:eco_kitchen/data/favorites_data.dart';

import '../auth/auth_gate.dart';
import '../backend/favorites_api.dart';
import '../backend/recipes_api.dart';
import '../backend/token_store.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _bottomNavIndex = 2; // Favorites tab is active
  final FavoritesApi _favoritesApi = FavoritesApi();
  final RecipesApi _recipesApi = RecipesApi();
  bool _isLoading = false;
  String? _errorMessage;
  List<FavoriteRecipe> _favorites = [];
  final Map<int, RecipeCard> _recipeCards = {};

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite,
    Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    _ensureAuthenticated();
    _loadFavorites();
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

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await _favoritesApi.fetchFavorites();
      if (!mounted) {
        return;
      }
      setState(() {
        _favorites = items;
        _isLoading = false;
      });
      await _loadRecipeCards(items);
      _syncLocalFavorites(items);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load favorites.';
      });
    }
  }

  Future<void> _loadRecipeCards(List<FavoriteRecipe> items) async {
    final ids = items.map((item) => item.recipeId).where((id) => id > 0).toSet();
    if (ids.isEmpty) {
      return;
    }
    final futures = ids.map((id) async {
      try {
        final detail = await _recipesApi.fetchRecipeDetail(id);
        return MapEntry(id, detail.card);
      } catch (_) {
        return null;
      }
    });
    final results = await Future.wait(futures);
    if (!mounted) {
      return;
    }
    setState(() {
      _recipeCards.clear();
      for (final entry in results) {
        if (entry != null) {
          _recipeCards[entry.key] = entry.value;
        }
      }
    });
  }

  void _syncLocalFavorites(List<FavoriteRecipe> items) {
    final existing = List<Map<String, dynamic>>.from(favoritesData.favorites);
    for (final item in existing) {
      final title = item['title']?.toString() ?? '';
      if (title.isNotEmpty) {
        favoritesData.removeFavorite(title);
      }
    }
    for (final item in items) {
      final card = _recipeCards[item.recipeId];
      final title =
          (card?.name.isNotEmpty == true) ? card!.name : item.recipeName;
      if (title.isEmpty) {
        continue;
      }
      final imageUrl = card?.imageUrl.isNotEmpty == true
          ? card!.imageUrl
          : item.recipeImageUrl;
      favoritesData.addFavorite({
        'id': item.recipeId,
        'title': title,
        'image': imageUrl.isNotEmpty ? imageUrl : 'assets/images/meal.png',
      });
    }
  }

  Future<void> _removeFavorite(FavoriteRecipe item) async {
    try {
      await _favoritesApi.removeFavorite(item.recipeId);
      await _loadFavorites();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not remove favorite. Please try again.'),
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
    final favorites = _favorites;

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
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Recipes grid or empty state
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        )
                      : favorites.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 64,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No favorites yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap the heart icon on recipes to add them here',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: favorites.length,
                              itemBuilder: (context, index) {
                                final recipe = favorites[index];
                                return _buildRecipeCard(
                                  title: recipe.recipeName,
                                  image: recipe.recipeImageUrl.isNotEmpty
                                      ? recipe.recipeImageUrl
                                      : 'assets/images/meal.png',
                                  index: index,
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard({
    required String title,
    required String image,
    required int index,
  }) {
    final recipe = _favorites[index];
    final card = _recipeCards[recipe.recipeId];
    final displayTitle =
        (card?.name.isNotEmpty == true) ? card!.name : title;
    final imageUrl =
        (card?.imageUrl.isNotEmpty == true) ? card!.imageUrl : image;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(
              recipeId: recipe.recipeId,
              title: displayTitle,
              image: imageUrl.isNotEmpty ? imageUrl : image,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with favorite button
          Expanded(
            child: Stack(
              children: [
                // Recipe image
                Container(
                  width: double.infinity,
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
                    child: _buildRecipeImage(imageUrl),
                  ),
                ),
                // Favorite button (remove from favorites)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _removeFavorite(recipe),
                    child: Container(
                      width: 32,
                      height: 32,
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
                        Icons.favorite,
                        color: Colors.red[400],
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Recipe title
          Text(
            displayTitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageFallback();
        },
      );
    }
    return _buildImageFallback();
  }

  Widget _buildImageFallback() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey[400],
          size: 32,
        ),
      ),
    );
  }
}
