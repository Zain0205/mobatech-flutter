import 'package:dio/dio.dart';

class ServiceRepository {
  final Dio dio;

  ServiceRepository(this.dio);

  Future<List<dynamic>> getServices() async {
    try {
      final response = await dio.get('/services');
      return response.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMsg = data is Map ? data['error'] : e.message;
      throw Exception(errorMsg ?? 'Failed to get services');
    }
  }
}
