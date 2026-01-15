import "dart:convert";

import "api_client.dart";

class ShoppingListItem {
  final int id;
  final String name;
  final double quantity;
  final String unit;
  final bool isChecked;

  const ShoppingListItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.isChecked,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json["id"] as int,
      name: json["name"] as String? ?? "",
      quantity: (json["quantity"] as num?)?.toDouble() ?? 0,
      unit: json["unit"] as String? ?? "",
      isChecked: json["is_checked"] as bool? ?? false,
    );
  }
}

class ShoppingListApi {
  final ApiClient _client;

  ShoppingListApi({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<ShoppingListItem>> fetchShoppingList() async {
    final response = await _client.get("/api/v1/shopping-list/");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (item) => ShoppingListItem.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }
    throw Exception(
      "ShoppingListApi.fetchShoppingList failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<void> addItem({
    required int ingredientCatalogId,
    required String name,
    required double quantity,
    required String unit,
  }) async {
    final response = await _client.post(
      "/api/v1/shopping-list/",
      {
        "ingredient_catalog_id": ingredientCatalogId,
        "name": name,
        "quantity": quantity,
        "unit": unit,
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw Exception(
      "ShoppingListApi.addItem failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<void> updateItem(
    int id, {
    double? quantity,
    String? unit,
    bool? isChecked,
  }) async {
    final payload = <String, dynamic>{};
    if (quantity != null) {
      payload["quantity"] = quantity;
    }
    if (unit != null) {
      payload["unit"] = unit;
    }
    if (isChecked != null) {
      payload["is_checked"] = isChecked;
    }

    var response = await _client.patch("/api/v1/shopping-list/$id", payload);
    if (response.statusCode == 307 || response.statusCode == 308) {
      final location = response.headers["location"] ??
          response.headers["Location"] ??
          response.headers["LOCATION"];
      if (location != null && location.isNotEmpty) {
        response = await _client.patch(location, payload);
      } else {
        final fallbackPath = "/api/v1/shopping-list/$id/";
        response = await _client.patch(fallbackPath, payload);
      }
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw Exception(
      "ShoppingListApi.updateItem failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<void> deleteItem(int id) async {
    final primaryPath = "/api/v1/shopping-list/$id";
    var response = await _client.delete(primaryPath);
    if (response.statusCode == 307 || response.statusCode == 308) {
      final location = response.headers["location"] ??
          response.headers["Location"] ??
          response.headers["LOCATION"];
      if (location != null && location.isNotEmpty) {
        response = await _client.delete(location);
      } else {
        final fallbackPath = primaryPath.endsWith("/")
            ? primaryPath.substring(0, primaryPath.length - 1)
            : "$primaryPath/";
        response = await _client.delete(fallbackPath);
      }
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw Exception(
      "ShoppingListApi.deleteItem failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<void> transferToInventory(int id) async {
    final primaryPath = "/api/v1/shopping-list/$id/transfer-to-inventory";
    var response = await _client.post(primaryPath, {});
    if (response.statusCode == 307 || response.statusCode == 308) {
      final location = response.headers["location"] ??
          response.headers["Location"] ??
          response.headers["LOCATION"];
      if (location != null && location.isNotEmpty) {
        response = await _client.post(location, {});
      } else {
        final fallbackPath = primaryPath.endsWith("/")
            ? primaryPath.substring(0, primaryPath.length - 1)
            : "$primaryPath/";
        response = await _client.post(fallbackPath, {});
      }
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw Exception(
      "ShoppingListApi.transferToInventory failed: ${response.statusCode} ${response.body}",
    );
  }
}
