import 'package:dio/dio.dart';

class EmergencyRepository {
  final Dio dio;

  EmergencyRepository(this.dio);

  Future<Map<String, dynamic>> submitRequest(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('/emergencies', data: data);
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final errorMsg = errorData is Map ? errorData['error'] : e.message;
      throw Exception(errorMsg ?? 'Failed to submit emergency request');
    }
  }

  Future<List<dynamic>> getHistory() async {
    try {
      final response = await dio.get('/emergencies/history');
      return response.data;
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final errorMsg = errorData is Map ? errorData['error'] : e.message;
      throw Exception(errorMsg ?? 'Failed to get history');
    }
  }
}
