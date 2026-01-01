import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  int _bottomNavIndex = 0;
  final TextEditingController _textController = TextEditingController();

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Shopping list items with checked state
  final List<Map<String, dynamic>> _items = [
    {'text': 'Drink 8 glasses of water', 'checked': false},
    {'text': 'Meditate for 10 minutes', 'checked': false},
    {'text': 'Read a chapter of a book', 'checked': false},
    {'text': 'Go for a 30-minute walk', 'checked': false},
    {'text': 'Write in a gratitude journal', 'checked': false},
    {'text': 'Plan meals for the day', 'checked': false},
    {'text': 'Practice deep breathing exercises', 'checked': false},
    {'text': 'Stretch for 15 minutes', 'checked': false},
  ];

  void _addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _items.add({
          'text': _textController.text,
          'checked': false,
        });
        _textController.clear();
      });
    }
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index]['checked'] = !_items[index]['checked'];
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
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
  void dispose() {
    _textController.dispose();
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'Shopping List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Shopping list items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _buildListItem(
                    text: item['text'],
                    checked: item['checked'],
                    onToggle: () => _toggleItem(index),
                    onDelete: () => _deleteItem(index),
                  );
                },
              ),
            ),

            // Add item input
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Add new item...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                        ),
                        onSubmitted: (_) => _addItem(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: _addItem,
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required String text,
    required bool checked,
    required VoidCallback onToggle,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: secondaryGreen.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: checked ? primaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: checked ? primaryGreen : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: checked
                    ? Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(width: 16),
            // Text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: checked ? Colors.grey[500] : Colors.black87,
                  decoration: checked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            // Delete button
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_outline,
                color: Colors.grey,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
