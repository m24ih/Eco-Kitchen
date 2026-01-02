import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class LeftoverScreen extends StatefulWidget {
  @override
  _LeftoverScreenState createState() => _LeftoverScreenState();
}

class _LeftoverScreenState extends State<LeftoverScreen> {
  int _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Sample ingredient data
  final List<Map<String, String>> _ingredients = [
    {'name': 'basmati rice', 'quantity': '½ cup'},
    {'name': 'chicken or vegetable broth', 'quantity': '16 fl oz'},
    {'name': 'cilantro', 'quantity': '½ small bunch'},
    {'name': 'coconut milk', 'quantity': '½ (13.5 fl oz) can'},
    {'name': 'garlic', 'quantity': '1 (1 inch) piece'},
    {'name': 'ginger root', 'quantity': '16 fl oz'},
    {'name': 'grape tomatoes', 'quantity': '1/2 pint'},
    {'name': 'jalapeño pepper', 'quantity': '1'},
    {'name': 'yellow onion', 'quantity': '1 medium'},
    {'name': 'cinnamon, ground', 'quantity': '1'},
  ];

  void _addIngredient() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add Ingredient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Ingredient name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  quantityController.text.isNotEmpty) {
                setState(() {
                  _ingredients.add({
                    'name': nameController.text,
                    'quantity': quantityController.text,
                  });
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${nameController.text} added!'),
                    backgroundColor: primaryGreen,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill in all fields'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            child: Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteIngredient(int index) {
    final deletedItem = _ingredients[index]['name'];
    setState(() {
      _ingredients.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deletedItem removed!'),
        backgroundColor: primaryGreen,
      ),
    );
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
            // Home icon tapped - navigate to HomeScreen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          } else {
            setState(() => _bottomNavIndex = index);
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with "What you have?" and + button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  // "What you have?" pill button
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Text(
                          'What you have ?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Add button
                  GestureDetector(
                    onTap: _addIngredient,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Ingredient list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _ingredients[index];
                  return _buildIngredientItem(
                    name: ingredient['name']!,
                    quantity: ingredient['quantity']!,
                    onDelete: () => _deleteIngredient(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientItem({
    required String name,
    required String quantity,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ingredient name
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Quantity
          Text(
            quantity,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 12),
          // Delete button
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.delete_outline,
              color: Colors.red[400],
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
