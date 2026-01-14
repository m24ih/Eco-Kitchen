import 'package:flutter/foundation.dart';

class FavoritesData extends ChangeNotifier {
  // Singleton yapısı
  static final FavoritesData _instance = FavoritesData._internal();
  factory FavoritesData() => _instance;
  FavoritesData._internal();

  // Favori Listesi
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  // Favori Ekle/Çıkar
  void toggleFavorite(Map<String, dynamic> recipe) {
    // Başlığa göre kontrol ediyoruz
    final index = _favorites.indexWhere((item) => item['title'] == recipe['title']);

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(recipe);
    }
    notifyListeners(); // Arayüzü güncelle!
  }

  void removeFavorite(String title) {
    _favorites.removeWhere((item) => item['title'] == title);
    notifyListeners(); // Arayüzü güncelle!
  }

  bool isFavorite(String title) {
    return _favorites.any((item) => item['title'] == title);
  }
}

// Geriye dönük uyumluluk için global değişken (Provider varken buna çok gerek yok ama kalsın)
final favoritesData = FavoritesData();