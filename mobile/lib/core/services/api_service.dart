import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// API base URL - Bu değeri env.dart dosyasından alabilirsiniz
const String baseUrl = 'http://localhost:8000'; // TODO: env.dart'tan alın

// Dio instance provider
final apiServiceProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Interceptor ekleyebilirsiniz (örneğin token ekleme)
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
});

