import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Gunakan 10.0.2.2 jika di Android Emulator, 127.0.0.1 jika Web/Linux
const String baseUrl = 'http://127.0.0.1:8080/api';

String? globalAuthToken;

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dio = Dio(options);

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      if (globalAuthToken != null) {
        options.headers['Authorization'] = 'Bearer $globalAuthToken';
      }
      return handler.next(options);
    },
  ));

  dio.interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
  ));

  return dio;
});
