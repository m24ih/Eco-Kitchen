import "dart:convert";

import "package:http/http.dart" as http;

import "../environment/env.dart";
import "token_store.dart";

class ApiClient {
  final http.Client _client;
  final TokenStore _tokenStore;

  ApiClient({
    http.Client? client,
    TokenStore? tokenStore,
  })  : _client = client ?? http.Client(),
        _tokenStore = tokenStore ?? TokenStore();

  Future<http.Response> get(String path) async {
    final uri = _buildUri(path);
    final headers = await _buildHeaders();
    return _client.get(uri, headers: headers);
  }

  Future<http.Response> post(String path, Map<String, dynamic> jsonBody) async {
    final uri = _buildUri(path);
    final headers = await _buildHeaders(includeJson: true);
    return _client.post(uri, headers: headers, body: jsonEncode(jsonBody));
  }

  Future<http.Response> delete(String path) async {
    final uri = _buildUri(path);
    final headers = await _buildHeaders();
    return _client.delete(uri, headers: headers);
  }

  Future<http.Response> patch(String path, Map<String, dynamic> jsonBody) async {
    final uri = _buildUri(path);
    final headers = await _buildHeaders(includeJson: true);
    return _client.patch(uri, headers: headers, body: jsonEncode(jsonBody));
  }

  Uri _buildUri(String path) {
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return Uri.parse(path);
    }
    final base = Env.baseUrl.endsWith("/")
        ? Env.baseUrl.substring(0, Env.baseUrl.length - 1)
        : Env.baseUrl;
    final normalizedPath = path.startsWith("/") ? path : "/$path";
    return Uri.parse("$base$normalizedPath");
  }

  Future<Map<String, String>> _buildHeaders({bool includeJson = false}) async {
    final headers = <String, String>{
      "Accept": "application/json",
    };
    if (includeJson) {
      headers["Content-Type"] = "application/json";
    }
    final token = await _tokenStore.getToken();
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }
}
