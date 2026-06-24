part of 'chat_provider.dart';

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

  Future<void> createNewSessionAndSend(
    String title,
    String message, {
    String? imagePath,
    String? filePath,
  }) async {
    final session = await _repository.createSession(title);
    final sessionId = session['ID'];
    _ref.read(currentSessionIdProvider.notifier).state = sessionId;
    _ref.invalidate(chatSessionsProvider); // refresh history
    state = [];
    await sendMessage(
      sessionId,
      message,
      imagePath: imagePath,
      filePath: filePath,
    );
  }

  Future<void> sendMessage(
    int sessionId,
    String message, {
    String? imagePath,
    String? filePath,
  }) async {
    if (isStreaming) return;

    _addOptimisticMessage(message, imagePath, filePath);
    isStreaming = true;

    try {
      await _streamResponse(sessionId, message);
    } catch (e) {
      // Handle error
    } finally {
      isStreaming = false;
    }
  }

  void _addOptimisticMessage(String message, String? imagePath, String? filePath) {
    state = [
      ...state,
      {
        'role': 'user',
        'content': message,
        'imagePath': imagePath,
        'filePath': filePath,
      },
      {'role': 'model', 'content': ''},
    ];
  }

  Future<void> _streamResponse(int sessionId, String message) async {
    final response = await _repository.dio.post(
      '/chat/sessions/$sessionId/stream',
      data: {'message': message},
      options: Options(
        responseType: ResponseType.stream,
        receiveTimeout: const Duration(minutes: 5),
      ),
    );

    final stream = response.data.stream;
    final stringStream = stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in stringStream) {
      _processStreamLine(line);
    }
  }

  void _processStreamLine(String line) {
    if (line.startsWith('data:')) {
      final dataStr = line.substring(5).trim();
      if (dataStr.isEmpty) return;
      try {
        final parsed = jsonDecode(dataStr);
        if (parsed['text'] != null) {
          _appendChunkToLastMessage(parsed['text']);
        }
      } catch (e) {
        _appendChunkToLastMessage(dataStr);
      }
    } else if (line.startsWith('event: error')) {
      // Handle SSE error event here
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
