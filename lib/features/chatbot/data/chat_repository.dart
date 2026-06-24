import 'package:dio/dio.dart';

class ChatRepository {
  final Dio dio;

  ChatRepository(this.dio);

  Future<List<dynamic>> getUserSessions() async {
    try {
      final response = await dio.get('/chat/sessions');
      return response.data;
    } on DioException { rethrow; }
  }

  Future<Map<String, dynamic>> createSession(String title) async {
    try {
      final response = await dio.post('/chat/sessions', data: {'title': title});
      return response.data;
    } on DioException { rethrow; }
  }

  Future<List<dynamic>> getSessionMessages(int sessionId) async {
    try {
      final response = await dio.get('/chat/sessions/$sessionId/messages');
      return response.data;
    } on DioException { rethrow; }
  }
}
