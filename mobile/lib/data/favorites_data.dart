import 'package:flutter/material.dart';

// Shared favorites data that can be accessed by multiple screens
class FavoritesData extends ChangeNotifier {
  static final FavoritesData _instance = FavoritesData._internal();
  factory FavoritesData() => _instance;
  FavoritesData._internal();

  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void addFavorite(Map<String, dynamic> recipe) {
    // Check if already exists
    bool exists = _favorites.any((item) => item['title'] == recipe['title']);
    if (!exists) {
      _favorites.add({...recipe, 'isFavorite': true});
      notifyListeners();
    }
  }

  void removeFavorite(String title) {
    _favorites.removeWhere((item) => item['title'] == title);
    notifyListeners();
  }

  void toggleFavorite(Map<String, dynamic> recipe) {
    bool exists = _favorites.any((item) => item['title'] == recipe['title']);
    if (exists) {
      removeFavorite(recipe['title']);
    } else {
      addFavorite(recipe);
    }
  }

  bool isFavorite(String title) {
    return _favorites.any((item) => item['title'] == title);
  }
}

// Global instance
final favoritesData = FavoritesData();
