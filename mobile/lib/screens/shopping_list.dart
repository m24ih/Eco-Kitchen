import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/profile.dart';

import '../backend/shopping_list_api.dart';
import 'add_shopping_list_item_screen.dart';
import '../auth/auth_gate.dart';
import '../backend/token_store.dart';

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
  final ShoppingListApi _shoppingListApi = ShoppingListApi();
  bool _isLoading = false;
  String? _errorMessage;

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  List<ShoppingListItem> _items = [];

  @override
  void initState() {
    super.initState();
    _ensureAuthenticated();
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
      return;
    }
    _loadShoppingList();
  }

  Future<void> _loadShoppingList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await _shoppingListApi.fetchShoppingList();
      if (!mounted) {
        return;
      }
      setState(() {
        _items = items;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addItem() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddShoppingListItemScreen()),
    );

    if (result == true) {
      _loadShoppingList();
    }
  }

  Future<void> _toggleItem(ShoppingListItem item) async {
    try {
      await _shoppingListApi.updateItem(
        item.id,
        isChecked: !item.isChecked,
      );
      await _loadShoppingList();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update item. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmDeleteItem(ShoppingListItem item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete item?'),
        content: Text('Remove ${item.name} from your shopping list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      _deleteItem(item);
    }
  }

  Future<void> _deleteItem(ShoppingListItem item) async {
    try {
      await _shoppingListApi.deleteItem(item.id);
      await _loadShoppingList();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} removed!'),
          backgroundColor: primaryGreen,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not delete item. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _transferItem(ShoppingListItem item) async {
    try {
      await _shoppingListApi.transferToInventory(item.id);
      await _loadShoppingList();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} moved to inventory.'),
          backgroundColor: primaryGreen,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not transfer item. Please try again.'),
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
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchRecipeScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
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
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? Center(
                          child: Text(
                            _errorMessage ?? 'No shopping list items yet.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return _buildListItem(
                              text:
                                  '${item.name} • ${formatQuantity(item.quantity, item.unit)}',
                              checked: item.isChecked,
                              onToggle: () => _toggleItem(item),
                              onDelete: () => _confirmDeleteItem(item),
                              onTransfer: () => _transferItem(item),
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
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Add new item...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                        ),
                        onTap: _addItem,
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
    required VoidCallback onTransfer,
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
              onTap: onTransfer,
              child: Icon(
                Icons.swap_horiz,
                color: Colors.grey,
                size: 22,
              ),
            ),
            SizedBox(width: 8),
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

  String formatQuantity(num quantity, String unit) {
    final normalizedUnit = unit.trim().toLowerCase();
    final value = quantity.toDouble();

    if (normalizedUnit == 'ml' && value >= 1000) {
      return '${_formatNumber(value / 1000)} L';
    }

    if (normalizedUnit == 'g' && value >= 1000) {
      return '${_formatNumber(value / 1000)} kg';
    }

    final trimmedUnit = unit.trim();
    final baseValue = _formatNumber(value);
    if (trimmedUnit.isEmpty) {
      return baseValue;
    }
    return '$baseValue $trimmedUnit';
  }

  String _formatNumber(double value) {
    final fixed = value.toStringAsFixed(1);
    return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
  }
}
