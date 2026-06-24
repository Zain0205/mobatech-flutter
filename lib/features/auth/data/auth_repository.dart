import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException { rethrow; }
  }

  Future<Map<String, dynamic>> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'full_name': fullName,
          'email': email,
          'phone_number': phone,
          'password': password,
        },
      );
      return response.data;
    } on DioException { rethrow; }
  }

  Future<Map<String, dynamic>> updateProfile(
    String fullName,
    String phone,
    String? imagePath, {
    String? bloodType,
    int? height,
    int? weight,
    String? allergies,
    String? dob,
    String? gender,
  }) async {
    try {
      Map<String, dynamic> mapData = {
        'full_name': fullName,
        'phone_number': phone,
      };
      if (bloodType != null) mapData['blood_type'] = bloodType;
      if (height != null) mapData['height'] = height.toString();
      if (weight != null) mapData['weight'] = weight.toString();
      if (allergies != null) mapData['allergies'] = allergies;
      if (dob != null) mapData['date_of_birth'] = dob;
      if (gender != null) mapData['gender'] = gender;

      FormData formData = FormData.fromMap(mapData);

      if (imagePath != null && !imagePath.startsWith('http')) {
        formData.files.add(
          MapEntry('image', await MultipartFile.fromFile(imagePath)),
        );
      }

      final response = await _dio.put('/users/profile', data: formData);
      return response.data;
    } on DioException { rethrow; }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } on DioException { rethrow; }
  }

  Future<Map<String, dynamic>> addFamilyMember(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.post('/users/family-members', data: payload);
      return response.data;
    } on DioException { rethrow; }
  }

  Future<void> deleteFamilyMember(int id) async {
    try {
      await _dio.delete('/users/family-members/$id');
    } on DioException { rethrow; }
  }
}
