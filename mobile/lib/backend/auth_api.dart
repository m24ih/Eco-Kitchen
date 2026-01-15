import "dart:convert";

import "package:http/http.dart" as http;

import "../environment/env.dart";
import "api_client.dart";

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => "ApiException($statusCode): $message";
}

class TokenResponse {
  final String accessToken;
  final String tokenType;

  const TokenResponse({
    required this.accessToken,
    required this.tokenType,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json["access_token"] as String? ?? "",
      tokenType: json["token_type"] as String? ?? "",
    );
  }
}

class AuthApi {
  final http.Client _client;
  final ApiClient _apiClient;

  AuthApi({http.Client? client})
      : _client = client ?? http.Client(),
        _apiClient = ApiClient(client: client);

  Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse("${Env.baseUrl}/api/v1/auth/login");
    final encodedBody = Uri(
      queryParameters: {
        "username": email.trim(),
        "password": password.trim(),
      },
    ).query;
    final response = await _client.post(
      uri,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: encodedBody,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return TokenResponse.fromJson(data);
    }

    print("AuthApi.login failed: ${response.statusCode} ${response.body}");
    throw Exception("AuthApi.login failed: ${response.statusCode} ${response.body}");
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final payload = {
      "name": name.trim(),
      "email": email.trim(),
      "password": password.trim(),
    };
    final response = await _apiClient.post(
      "/api/v1/auth/register",
      payload,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    if (response.statusCode == 409) {
      throw const ApiException(409, "This email is already in use.");
    }

    if (response.statusCode == 422) {
      throw const ApiException(
        422,
        "Please enter a valid email address.",
      );
    }

    throw ApiException(
      response.statusCode,
      "Something went wrong. Please try again.",
    );
  }

  Future<Map<String, dynamic>> me() async {
    final response = await _apiClient.get("/api/v1/auth/me");
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception("AuthApi.me failed: ${response.statusCode} ${response.body}");
  }
}
