import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/history.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class AiChefScreen extends StatefulWidget {
  @override
  _AiChefScreenState createState() => _AiChefScreenState();
}

class _AiChefScreenState extends State<AiChefScreen> {
  int _bottomNavIndex = 0;
  final TextEditingController _messageController = TextEditingController();

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Sample chat messages
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': true,
      'text': 'I want some sweet recipes',
    },
    {
      'isUser': false,
      'text':
          'Absouletly ! Based on your preferences I have curatured 20 sweet recipes just for you. Ready to explore them ?',
      'recipe': {
        'title': 'Chicken Curry',
        'image': 'assets/images/meal.png',
        'rating': 5,
        'description':
            'This recipe requires basic ingredients and minimal prep time, making it ideal for busy days...',
        'time': '45 min',
        'servings': '2,458',
        'isFavorite': true,
      },
    },
  ];

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
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
                    'reCook ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  Text(
                    'AI Chef',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryGreen,
                    ),
                  ),
                  Spacer(),
                  // Menu icon
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()),
                      );
                    },
                    child: Icon(
                      Icons.menu,
                      color: primaryGreen,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Chat messages
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  if (message['isUser']) {
                    return _buildUserMessage(message['text']);
                  } else {
                    return _buildAiMessage(message);
                  }
                },
              ),
            ),

            // Message input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: secondaryGreen.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Voice input
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.mic_none,
                          color: primaryGreen,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),

            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'You',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Container(
          margin: EdgeInsets.only(left: 60),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: secondaryGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text.isEmpty ? '  ' : text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAiMessage(Map<String, dynamic> message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Chef',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        // AI response bubble
        Container(
          margin: EdgeInsets.only(right: 40),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: secondaryGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message['text'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(height: 12),
        // Recipe card if exists
        if (message['recipe'] != null) _buildRecipeCard(message['recipe']),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return Container(
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
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    recipe['isFavorite']
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: recipe['isFavorite'] ? Colors.red[400] : Colors.grey,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          // Recipe info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and rating
                Row(
                  children: [
                    Text(
                      recipe['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.star, color: Colors.white, size: 14),
                    SizedBox(width: 2),
                    Text(
                      '${recipe['rating']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                // Description and details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        recipe['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              recipe['time'],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              recipe['servings'],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chat_bubble_outline,
                                color: Colors.white, size: 12),
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
    );
  }
}
