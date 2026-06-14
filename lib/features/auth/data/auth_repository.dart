import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMsg = data is Map ? data['error'] : e.message;
      throw Exception(errorMsg ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> register(String fullName, String email, String phone, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'full_name': fullName,
        'email': email,
        'phone_number': phone,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMsg = data is Map ? data['error'] : e.message;
      throw Exception(errorMsg ?? 'Register failed');
    }
  }
}
