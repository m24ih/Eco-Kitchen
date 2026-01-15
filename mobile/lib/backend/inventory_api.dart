import "dart:convert";

import "api_client.dart";

class InventoryItem {
  final int id;
  final String name;
  final double quantity;
  final String unit;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json["id"] as int,
      name: json["name"] as String? ?? "",
      quantity: (json["quantity"] as num?)?.toDouble() ?? 0,
      unit: json["unit"] as String? ?? "",
    );
  }
}

class InventoryApi {
  final ApiClient _client;

  InventoryApi({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<InventoryItem>> fetchInventory() async {
    final response = await _client.get("/api/v1/inventory/");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => InventoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception(
      "InventoryApi.fetchInventory failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<void> addInventoryItem({
    required int ingredientCatalogId,
    required String name,
    required double quantity,
    required String unit,
  }) async {
    final path = "/api/v1/inventory/";
    final response = await _client.post(
      path,
      {
        "ingredient_catalog_id": ingredientCatalogId,
        "name": name,
        "quantity": quantity,
        "unit": unit,
      },
    );
    print("InventoryApi.addInventoryItem -> ${response.request?.url}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    print(
      "InventoryApi.addInventoryItem failed: ${response.statusCode} ${response.body}",
    );
    throw Exception(
      "InventoryApi.addInventoryItem failed: ${response.statusCode} ${response.body}",
    );
  }

  Future<void> deleteInventoryItem(int id) async {
    final primaryPath = "/api/v1/inventory/$id";
    var response = await _client.delete(primaryPath);
    print("InventoryApi.deleteInventoryItem -> ${response.request?.url}");
    print(
      "InventoryApi.deleteInventoryItem status: ${response.statusCode}",
    );

    if (response.statusCode == 307 || response.statusCode == 308) {
      final location = response.headers["location"] ??
          response.headers["Location"] ??
          response.headers["LOCATION"];
      print("InventoryApi.deleteInventoryItem redirect: $location");
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
      "InventoryApi.deleteInventoryItem failed: ${response.statusCode} ${response.body}",
    );
  }
}
