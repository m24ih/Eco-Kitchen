import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importlar
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/account.dart';
import 'package:eco_kitchen/screens/evaluate.dart';
// Yeni Provider'ı ekliyoruz
import 'package:eco_kitchen/providers/favorites_provider.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class RecipeScreen extends ConsumerStatefulWidget {
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

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  int _bottomNavIndex = -1;
  int _selectedTab = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Navigasyon
  void _onNavigationTap(int index) {
    setState(() => _bottomNavIndex = index);
    Widget page;
    switch (index) {
      case 0: page = HomeScreen(); break;
      case 1: page = SearchRecipeScreen(); break;
      case 2: page = FavoritesScreen(); break;
      case 3: page = AccountScreen(); break;
      default: return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  // Veriler (Aynı kalıyor)
  final Map<String, dynamic> _recipeData = {
    'time': '35 minutes', 'servings': '2 servings',
    'nutrition': {'carbs': '65g carbs', 'proteins': '27g proteins', 'kcal': '120 Kcal', 'fats': '91g fats'},
    'ingredients': [
      {'name': 'basmati rice', 'quantity': '½ cup'},
      {'name': 'chicken/veg broth', 'quantity': '16 fl oz'},
      // ... Diğerleri
    ],
    'instructions': [
      {'step': 1, 'text': 'Rinse rice...', 'ingredients': []},
      {'step': 2, 'text': 'Boil water...', 'ingredients': []},
    ],
  };

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AiChefScreen())),
      backgroundColor: primaryGreen,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain, width: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 ÖNEMLİ DEĞİŞİKLİK: Provider'ı dinliyoruz
    final favorites = ref.watch(favoritesProvider);
    bool isFav = favorites.isFavorite(widget.title);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _buildFAB(),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: primaryGreen, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.rate_review, color: primaryGreen),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EvaluateScreen(recipeTitle: widget.title, recipeImage: widget.image))),
                    ),
                  ],
                ),
              ),

              // Image & Fav Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.image,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(height: 250, color: Colors.grey[200], child: Icon(Icons.image)),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          // 🔥 ÖNEMLİ DEĞİŞİKLİK: Provider üzerinden işlem yapıyoruz
                          ref.read(favoritesProvider).toggleFavorite({
                            'title': widget.title,
                            'image': widget.image,
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Tabs
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
              if (_selectedTab == 0) _buildCookwareTab(),
              if (_selectedTab == 1) _buildIngredientsTab(),
              if (_selectedTab == 2) _buildInstructionsTab(),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // --- Yardımcı Widget'lar (Kısaltılmış) ---
  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[100] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey[300]!),
        ),
        child: Center(child: Text(text, style: TextStyle(color: isSelected ? Colors.orange[800] : Colors.grey[600], fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _buildCookwareTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("${_recipeData['time']} • ${_recipeData['servings']}", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 16),
          // Besin değerleri buraya... (Önceki kodla aynı mantık)
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: (_recipeData['ingredients'] as List).map((e) => ListTile(title: Text(e['name']), trailing: Text(e['quantity']))).toList(),
      ),
    );
  }

  Widget _buildInstructionsTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: (_recipeData['instructions'] as List).map((e) => ListTile(leading: Text("${e['step']}", style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen)), title: Text(e['text']))).toList(),
      ),
    );
  }
}