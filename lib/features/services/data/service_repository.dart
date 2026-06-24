import 'package:dio/dio.dart';

class ServiceRepository {
  final Dio dio;

  ServiceRepository(this.dio);

  Future<List<dynamic>> getServices() async {
    try {
      final response = await dio.get('/services');
      return response.data;
    } on DioException { rethrow; }
  }
}
