import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_kitchen/data/favorites_data.dart';

// ChangeNotifierProvider ile FavoritesData sınıfını dinliyoruz
final favoritesProvider = ChangeNotifierProvider<FavoritesData>((ref) {
  return FavoritesData();
});