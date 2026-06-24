import 'dart:convert';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/chat_repository.dart';
import 'package:dio/dio.dart';

part 'chat_messages_notifier.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(ref.watch(dioProvider));
});

final chatSessionsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return await repo.getUserSessions();
});

final currentSessionIdProvider = StateProvider<int?>((ref) => null);

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return ChatMessagesNotifier(ref.watch(chatRepositoryProvider), ref);
    });

final isChatHistoryLoadingProvider = StateProvider<bool>((ref) => false);
