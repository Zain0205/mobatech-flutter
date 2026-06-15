import 'dart:convert';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/chat_repository.dart';
import 'package:dio/dio.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(ref.watch(dioProvider));
});

final chatSessionsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return await repo.getUserSessions();
});

final currentSessionIdProvider = StateProvider<int?>((ref) => null);

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<Map<String, dynamic>>>((ref) {
  return ChatMessagesNotifier(ref.watch(chatRepositoryProvider), ref);
});

final isChatHistoryLoadingProvider = StateProvider<bool>((ref) => false);

class ChatMessagesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final ChatRepository _repository;
  final Ref _ref;
  bool isStreaming = false;

  ChatMessagesNotifier(this._repository, this._ref) : super([]);

  void clearMessages() {
    state = [];
  }

  Future<void> loadSession(int sessionId) async {
    _ref.read(isChatHistoryLoadingProvider.notifier).state = true;
    _ref.read(currentSessionIdProvider.notifier).state = sessionId;
    state = [];
    try {
      final messages = await _repository.getSessionMessages(sessionId);
      state = List<Map<String, dynamic>>.from(messages);
    } finally {
      _ref.read(isChatHistoryLoadingProvider.notifier).state = false;
    }
  }

  Future<void> deleteSession(int sessionId) async {
    try {
      await _repository.dio.delete('/chat/sessions/$sessionId');
      if (_ref.read(currentSessionIdProvider) == sessionId) {
        _ref.read(currentSessionIdProvider.notifier).state = null;
        state = [];
      }
      _ref.invalidate(chatSessionsProvider);
    } catch (e) {
      // Ignored for now
    }
  }

  Future<void> createNewSessionAndSend(String title, String message) async {
    final session = await _repository.createSession(title);
    final sessionId = session['ID'];
    _ref.read(currentSessionIdProvider.notifier).state = sessionId;
    _ref.invalidate(chatSessionsProvider); // refresh history
    state = [];
    await sendMessage(sessionId, message);
  }

  Future<void> sendMessage(int sessionId, String message) async {
    if (isStreaming) return;
    
    // Optimistic UI for user message
    state = [...state, {'role': 'user', 'content': message}];
    isStreaming = true;
    
    // Empty message for model response to stream into
    state = [...state, {'role': 'model', 'content': ''}];

    try {
      final response = await _repository.dio.post(
        '/chat/sessions/$sessionId/stream',
        data: {'message': message},
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(minutes: 5), // Long timeout for streaming
        ),
      );

      final stream = response.data.stream;
      final stringStream = stream.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter());

      await for (final line in stringStream) {
        if (line.startsWith('data:')) {
          final dataStr = line.substring(5).trim();
          if (dataStr.isEmpty) continue;
          try {
            final parsed = jsonDecode(dataStr);
            if (parsed['text'] != null) {
              _appendChunkToLastMessage(parsed['text']);
            }
          } catch (e) {
            // Fallback just in case
            _appendChunkToLastMessage(dataStr);
          }
        } else if (line.startsWith('event: error')) {
          // Handle SSE error event here
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      isStreaming = false;
    }
  }

  void _appendChunkToLastMessage(String chunk) {
    if (state.isEmpty) return;
    final messages = List<Map<String, dynamic>>.from(state);
    final lastMessage = Map<String, dynamic>.from(messages.last);
    
    lastMessage['content'] = lastMessage['content'] + chunk;
    messages[messages.length - 1] = lastMessage;
    
    state = messages;
  }
}
