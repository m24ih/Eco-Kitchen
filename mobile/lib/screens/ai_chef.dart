import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/history.dart';
import 'package:eco_kitchen/screens/recipe.dart';
import 'package:eco_kitchen/screens/profile.dart';
import 'package:eco_kitchen/data/favorites_data.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class AiChefScreen extends StatefulWidget {
  @override
  _AiChefScreenState createState() => _AiChefScreenState();
}

class _AiChefScreenState extends State<AiChefScreen> {
  int _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Sample recipe data
  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Chicken Curry',
      'image': 'assets/images/meal.png',
      'time': '45 min',
      'rating': 5,
      'servings': '2,458',
      'description':
          'This recipe requires basic ingredients and minimal prep time, making it ideal for busy days...',
      'isFavorite': true,
    },
    {
      'title': 'Vegetable Stir Fry',
      'image': 'assets/images/meal.png',
      'time': '25 min',
      'rating': 4.5,
      'servings': '1,832',
      'description':
          'A healthy and colorful mix of fresh vegetables with a savory sauce...',
      'isFavorite': false,
    },
    {
      'title': 'Pasta Primavera',
      'image': 'assets/images/meal.png',
      'time': '30 min',
      'rating': 4.7,
      'servings': '3,105',
      'description':
          'Classic Italian pasta with seasonal vegetables and parmesan cheese...',
      'isFavorite': true,
    },
    {
      'title': 'Grilled Salmon',
      'image': 'assets/images/meal.png',
      'time': '35 min',
      'rating': 4.9,
      'servings': '2,891',
      'description':
          'Fresh salmon fillet grilled to perfection with herbs and lemon...',
      'isFavorite': false,
    },
    {
      'title': 'Mushroom Risotto',
      'image': 'assets/images/meal.png',
      'time': '40 min',
      'rating': 4.8,
      'servings': '1,654',
      'description':
          'Creamy Italian rice dish with wild mushrooms and white wine...',
      'isFavorite': true,
    },
  ];

  void _navigateToRecipe(Map<String, dynamic> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeScreen(
          title: recipe['title'],
          image: recipe['image'],
        ),
      ),
    );
  }

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
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Scrollable content (recipes)
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe cards
                        ..._recipes
                            .map((recipe) => _buildRecipeCard(recipe))
                            .toList(),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating AI Assistant Button
          Positioned(
            left: 16,
            bottom: 20,
            child: _buildAiAssistantButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAssistantButton() {
    return GestureDetector(
      onTap: _showAiOptions,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: secondaryGreen,
          shape: BoxShape.circle,
          border: Border.all(color: primaryGreen, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.chat_bubble_outline,
          color: primaryGreen,
          size: 28,
        ),
      ),
    );
  }

  void _showAllergyDialog() {
    List<String> allergies = [
      'Peanuts',
      'Gluten',
      'Dairy',
      'Eggs',
      'Shellfish',
      'Soy',
      'Fish',
      'Sesame',
    ];
    List<String> selectedAllergies = [];
    TextEditingController customAllergyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Select Allergies',
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Add Custom Allergy'),
                      content: TextField(
                        controller: customAllergyController,
                        decoration: InputDecoration(
                          hintText: 'Enter allergy name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (customAllergyController.text.isNotEmpty) {
                              setState(() {
                                allergies.add(customAllergyController.text);
                                selectedAllergies
                                    .add(customAllergyController.text);
                              });
                              customAllergyController.clear();
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                          ),
                          child: Text('Add',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: secondaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: primaryGreen, size: 20),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Which foods are you allergic to?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allergies.map((allergy) {
                    bool isSelected = selectedAllergies.contains(allergy);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedAllergies.remove(allergy);
                          } else {
                            selectedAllergies.add(allergy);
                          }
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryGreen : lightGreen,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryGreen,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          allergy,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : primaryGreen,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (selectedAllergies.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Filtering recipes without ${selectedAllergies.join(", ")}...'),
                      backgroundColor: primaryGreen,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAiOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: secondaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'AI Chef Assistant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'What kind of recipes would you like to see?',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              // Options
              _buildAiOptionItem(Icons.eco, 'Vegetarian', 'Meat-free recipes'),
              _buildAiOptionItem(Icons.cake, 'Dessert', 'Sweet recipes'),
              _buildAiOptionItem(
                  Icons.dinner_dining, 'Savory', 'Savory dishes'),
              _buildAiOptionItem(Icons.timer, 'Faster', 'Less than 30 minutes'),
              _buildAiOptionItem(
                  Icons.warning_amber, 'Allergy', 'Filter by allergens'),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiOptionItem(IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (title == 'Allergy') {
          _showAllergyDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Filtering $title recipes...'),
              backgroundColor: primaryGreen,
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryGreen.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryGreen, size: 24),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: primaryGreen, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: secondaryGreen,
              shape: BoxShape.circle,
              border: Border.all(color: primaryGreen, width: 2),
            ),
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          // Title
          Text(
            'AI Chef',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryGreen,
            ),
          ),
          Spacer(),
          // Menu icon with popup
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              } else if (value == 'new_chat') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Yeni sohbet başlatıldı!'),
                    backgroundColor: primaryGreen,
                  ),
                );
              }
            },
            icon: Icon(
              Icons.menu,
              color: primaryGreen,
              size: 26,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            elevation: 4,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'history',
                child: Row(
                  children: [
                    Icon(Icons.history, color: primaryGreen, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'History',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'new_chat',
                child: Row(
                  children: [
                    Icon(Icons.add_comment_outlined,
                        color: primaryGreen, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'New Chat',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () => _navigateToRecipe(recipe),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    recipe['image'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        recipe['isFavorite'] = !(recipe['isFavorite'] ?? false);
                      });
                      // Gerçekten favorilere ekle/çıkar
                      favoritesData.toggleFavorite(recipe);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            recipe['isFavorite'] == true
                                ? '${recipe['title']} favorilere eklendi!'
                                : '${recipe['title']} favorilerden çıkarıldı!',
                          ),
                          backgroundColor: primaryGreen,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        recipe['isFavorite'] == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: recipe['isFavorite'] == true
                            ? Colors.red[400]
                            : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Recipe info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating
                  Row(
                    children: [
                      Text(
                        recipe['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.star, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${recipe['rating']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Description and details
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          recipe['description'] ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                recipe['time'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                recipe['servings'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.chat_bubble_outline,
                                  color: Colors.white, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
