import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Localhost mapping for emulator/web environment bridging.
const String baseUrl = 'http://127.0.0.1:8080/api';

String? globalAuthToken;

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  final dio = Dio(options);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (globalAuthToken != null) {
          options.headers['Authorization'] = 'Bearer $globalAuthToken';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Extract payload from standard API response envelope.
        if (response.data != null && response.data is Map<String, dynamic>) {
          if (response.data['success'] == true &&
              response.data.containsKey('data')) {
            response.data = response.data['data'];
          }
        }
        return handler.next(response);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ),
  );

  return dio;
});
