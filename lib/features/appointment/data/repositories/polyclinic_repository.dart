import 'package:dio/dio.dart';
import '../models/polyclinic.dart';

class PolyclinicRepository {
  final Dio _dio;

  PolyclinicRepository(this._dio);

  Future<List<Polyclinic>> getPolyclinics() async {
    try {
      final response = await _dio.get('/polyclinics');
      final List<dynamic> data = response.data ?? [];
      return data.map((json) => Polyclinic.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Polyclinic> getPolyclinicById(int id) async {
    try {
      final response = await _dio.get('/polyclinics/$id');
      return Polyclinic.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
