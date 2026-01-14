import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/ai_chef.dart';
import 'package:eco_kitchen/screens/search_recipe.dart';
import 'package:eco_kitchen/screens/favorites.dart';
import 'package:eco_kitchen/screens/profile.dart';
// Yeni Provider
import 'package:eco_kitchen/providers/inventory_provider.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class LeftoverScreen extends ConsumerStatefulWidget {
  @override
  _LeftoverScreenState createState() => _LeftoverScreenState();
}

class _LeftoverScreenState extends ConsumerState<LeftoverScreen> {
  int _bottomNavIndex = -1;

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  // Ekleme Diyaloğu
  void _addIngredient() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    String selectedUnit = 'piece'; // Varsayılan birim

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add Ingredient to Inventory'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // İsim
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Ingredient Name (e.g. onion)',
                border: OutlineInputBorder(),
                hintText: 'Must match catalog (english for now)',
              ),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                // Miktar (Sayı)
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Birim Seçimi
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedUnit,
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: ['piece', 'kg', 'g', 'ml', 'l', 'clove', 'tbsp', 'tsp']
                        .map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    ))
                        .toList(),
                    onChanged: (value) {
                      selectedUnit = value!;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                try {
                  final quantity = double.parse(quantityController.text.replaceAll(',', '.'));

                  // Provider üzerinden ekle
                  await ref.read(inventoryProvider.notifier).addItem(
                    nameController.text,
                    quantity,
                    selectedUnit,
                  );

                  if (context.mounted) Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${nameController.text} added!'), backgroundColor: primaryGreen),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            child: Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onNavigationTap(int index) {
    setState(() {
      _bottomNavIndex = index;
    });

    Widget page;
    switch (index) {
      case 0: page = HomeScreen(); break;
      case 1: page = SearchRecipeScreen(); break;
      case 2: page = FavoritesScreen(); break;
      case 3: page = ProfileScreen(); break;
      default: return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    // Provider'ı dinle
    final inventoryState = ref.watch(inventoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AiChefScreen())),
        backgroundColor: primaryGreen,
        child: Container(width: 50, height: 50, padding: EdgeInsets.all(2), decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle), child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 25, rightCornerRadius: 25,
        backgroundColor: secondaryGreen,
        activeColor: primaryGreen,
        inactiveColor: primaryGreen.withOpacity(0.6),
        splashSpeedInMilliseconds: 300,
        notchMargin: 8,
        onTap: _onNavigationTap,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(24)),
                      child: Center(child: Text('Your Inventory', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: _addIngredient,
                    child: Container(width: 48, height: 48, decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle), child: Icon(Icons.add, color: Colors.white, size: 28)),
                  ),
                ],
              ),
            ),

            // LİSTE GÖRÜNÜMÜ (AsyncValue ile)
            Expanded(
              child: inventoryState.when(
                data: (items) => items.isEmpty
                    ? Center(child: Text("Your fridge is empty. Add items!", style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildIngredientItem(
                      id: item['id'],
                      name: item['name'],
                      quantity: "${item['quantity']} ${item['unit']}",
                    );
                  },
                ),
                loading: () => Center(child: CircularProgressIndicator(color: primaryGreen)),
                error: (err, stack) => Center(child: Text("Failed to load inventory: $err")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientItem({required int id, required String name, required String quantity}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87))),
          Text(quantity, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              // Silme işlemi
              ref.read(inventoryProvider.notifier).deleteItem(id);
            },
            child: Icon(Icons.delete_outline, color: Colors.red[400], size: 22),
          ),
        ],
      ),
    );
  }
}