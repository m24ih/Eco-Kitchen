import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // Platform kontrolü için

final apiServiceProvider = Provider<Dio>((ref) {
  // Base URL ayarı (Android Emülatör vs iOS Simülatör ayrımı)
  final String baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api/v1'
      : 'http://127.0.0.1:8000/api/v1';

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // --- TOKEN INTERCEPTOR (ARAYA GİRİCİ) ---
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // 1. Her istekten önce hafızadan token'ı oku
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // 2. Eğer token varsa, isteğin Header'ına ekle
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        print("🔐 Token eklendi: Bearer ${token.substring(0, 10)}..."); // Debug için
      }

      return handler.next(options); // İsteği yola devam ettir
    },
    onError: (DioException e, handler) {
      // 401 hatası alınırsa (Token süresi dolmuşsa) burada logout işlemi yapılabilir
      print("❌ API Hatası: ${e.response?.statusCode} - ${e.message}");
      return handler.next(e);
    },
  ));

  return dio;
});