import "dart:convert";

import "api_client.dart";

class CatalogItem {
  final int id;
  final String name;
  final String defaultUnit;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.defaultUnit,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) {
    return CatalogItem(
      id: json["id"] as int,
      name: json["name"] as String? ?? "",
      defaultUnit: json["default_unit"] as String? ?? "",
    );
  }
}

class CatalogApi {
  final ApiClient _client;

  CatalogApi({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<CatalogItem>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return [];
    }

    final encoded = Uri.encodeQueryComponent(trimmed);
    final response = await _client.get("/api/v1/catalog/search?q=$encoded");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => CatalogItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception(
      "CatalogApi.search failed: ${response.statusCode} ${response.body}",
    );
  }
}
