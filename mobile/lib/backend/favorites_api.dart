import "dart:convert";

import "api_client.dart";

class FavoriteRecipe {
  final int id;
  final int recipeId;
  final String recipeName;
  final String recipeImageUrl;

  const FavoriteRecipe({
    required this.id,
    required this.recipeId,
    required this.recipeName,
    required this.recipeImageUrl,
  });

  factory FavoriteRecipe.fromJson(Map<String, dynamic> json) {
    return FavoriteRecipe(
      id: json["id"] as int? ?? 0,
      recipeId: json["recipe_id"] as int? ?? 0,
      recipeName: json["recipe_name"] as String? ?? "",
      recipeImageUrl: json["recipe_image_url"] as String? ?? "",
    );
  }
}

class FavoritesApi {
  final ApiClient _client;

  FavoritesApi({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<FavoriteRecipe>> fetchFavorites() async {
    final response = await _client.get("/api/v1/favorites/recipes");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => FavoriteRecipe.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    print(
      "FavoritesApi.fetchFavorites failed: ${response.request?.url} ${response.statusCode} ${response.body}",
    );
    throw Exception(
      "FavoritesApi.fetchFavorites failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<void> addFavorite(int recipeId) async {
    final primaryPath = "/api/v1/favorites/recipes/$recipeId";
    var response = await _client.post(primaryPath, {});
    if (response.statusCode == 307 || response.statusCode == 308) {
      final location = response.headers["location"] ??
          response.headers["Location"] ??
          response.headers["LOCATION"];
      if (location != null && location.isNotEmpty) {
        response = await _client.post(location, {});
      } else {
        response = await _client.post("$primaryPath/", {});
      }
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    print(
      "FavoritesApi.addFavorite failed: ${response.request?.url} ${response.statusCode} ${response.body}",
    );
    throw Exception(
      "FavoritesApi.addFavorite failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<void> removeFavorite(int recipeId) async {
    final primaryPath = "/api/v1/favorites/recipes/$recipeId";
    var response = await _client.delete(primaryPath);
    if (response.statusCode == 307 || response.statusCode == 308) {
      final location = response.headers["location"] ??
          response.headers["Location"] ??
          response.headers["LOCATION"];
      if (location != null && location.isNotEmpty) {
        response = await _client.delete(location);
      } else {
        response = await _client.delete("$primaryPath/");
      }
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    print(
      "FavoritesApi.removeFavorite failed: ${response.request?.url} ${response.statusCode} ${response.body}",
    );
    throw Exception(
      "FavoritesApi.removeFavorite failed: ${response.statusCode} ${response.body}",
    );
  }
}
