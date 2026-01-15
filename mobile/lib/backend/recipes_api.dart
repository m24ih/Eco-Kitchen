import "dart:convert";

import "api_client.dart";

class RecipeCard {
  final int id;
  final String name;
  final String imageUrl;
  final int? servings;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final String? difficulty;
  final int? caloriesKcal;
  final double? carbsG;
  final double? proteinG;
  final double? fatG;
  final bool isFeatured;

  const RecipeCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.servings,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.caloriesKcal,
    required this.carbsG,
    required this.proteinG,
    required this.fatG,
    required this.isFeatured,
  });

  factory RecipeCard.fromJson(Map<String, dynamic> json) {
    return RecipeCard(
      id: json["id"] as int? ?? 0,
      name: json["name"] as String? ?? "",
      imageUrl: json["image_url"] as String? ?? "",
      servings: json["servings"] as int?,
      prepTimeMinutes: json["prep_time_minutes"] as int?,
      cookTimeMinutes: json["cook_time_minutes"] as int?,
      difficulty: json["difficulty"] as String?,
      caloriesKcal: json["calories_kcal"] as int?,
      carbsG: (json["carbs_g"] as num?)?.toDouble(),
      proteinG: (json["protein_g"] as num?)?.toDouble(),
      fatG: (json["fat_g"] as num?)?.toDouble(),
      isFeatured: json["is_featured"] as bool? ?? false,
    );
  }
}

class RecipeIngredient {
  final String name;
  final String amountText;
  final double? quantity;
  final String unit;
  final String? note;

  const RecipeIngredient({
    required this.name,
    required this.amountText,
    required this.quantity,
    required this.unit,
    required this.note,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json["name"] as String? ?? "",
      amountText: json["amount_text"] as String? ?? "",
      quantity: (json["quantity"] as num?)?.toDouble(),
      unit: json["unit"] as String? ?? "",
      note: json["note"] as String?,
    );
  }
}

class RecipeStep {
  final int stepNumber;
  final String text;
  final List<String> ingredients;

  const RecipeStep({
    required this.stepNumber,
    required this.text,
    required this.ingredients,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    final ingredients = (json["ingredients"] as List<dynamic>? ?? [])
        .map((item) {
          if (item is Map<String, dynamic>) {
            return item["amount_text"] as String? ?? item["name"] as String? ?? "";
          }
          return item.toString();
        })
        .where((value) => value.isNotEmpty)
        .toList();
    return RecipeStep(
      stepNumber: json["step_number"] as int? ?? 0,
      text: json["text"] as String? ?? "",
      ingredients: ingredients,
    );
  }
}

class RecipeDetail {
  final RecipeCard card;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  const RecipeDetail({
    required this.card,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = (json["ingredients"] as List<dynamic>? ?? [])
        .map((item) => RecipeIngredient.fromJson(item as Map<String, dynamic>))
        .toList();
    final steps = (json["steps"] as List<dynamic>? ?? [])
        .map((item) => RecipeStep.fromJson(item as Map<String, dynamic>))
        .toList();
    return RecipeDetail(
      card: RecipeCard.fromJson(json),
      ingredients: ingredients,
      steps: steps,
    );
  }
}

class RecipesApi {
  final ApiClient _client;

  RecipesApi({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<RecipeCard>> fetchRecipes({
    bool? featured,
    int limit = 20,
    int offset = 0,
  }) async {
    final effectiveLimit = limit > 50 ? 50 : limit;
    final queryParams = <String, String>{
      "limit": effectiveLimit.toString(),
      "offset": offset.toString(),
    };
    if (featured == true) {
      queryParams["featured"] = "true";
    }
    final uri = Uri(path: "/api/v1/recipes/").replace(queryParameters: queryParams);
    final response = await _client.get(uri.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final items = _parseListResponse(response.body);
      if (items.isNotEmpty) {
        final first = items.first;
        print("RecipesApi.fetchRecipes first: ${first.id} ${first.name}");
      }
      return items;
    }
    print(
      "RecipesApi.fetchRecipes failed: ${response.request?.url} ${response.statusCode} ${response.body}",
    );
    throw Exception(
      "RecipesApi.fetchRecipes failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<RecipeDetail> fetchRecipeDetail(int recipeId) async {
    final response = await _client.get("/api/v1/recipes/$recipeId");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return RecipeDetail.fromJson(data);
    }
    print(
      "RecipesApi.fetchRecipeDetail failed: ${response.request?.url} ${response.statusCode} ${response.body}",
    );
    throw Exception(
      "RecipesApi.fetchRecipeDetail failed: ${response.statusCode} ${response.body}",
    );
  }

  List<RecipeCard> _parseListResponse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is List) {
      return decoded
          .map((item) => RecipeCard.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    if (decoded is Map<String, dynamic>) {
      final container = decoded["items"] ?? decoded["results"] ?? decoded["data"];
      if (container is List) {
        return container
            .map((item) => RecipeCard.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    print("RecipesApi.fetchRecipes empty list: unexpected response shape");
    return [];
  }
}
