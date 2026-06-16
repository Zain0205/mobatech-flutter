import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_area.dart';
import '../../../../core/widgets/skeleton_loader.dart';

import '../providers/chat_provider.dart';

class ChatbotScreen extends ConsumerWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoadingHistory = ref.watch(isChatHistoryLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
          _buildHeader(context, ref),
          Expanded(
            child: isLoadingHistory
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ChatBubble(
                        text: '',
                        time: '',
                        isUser: index % 2 == 1,
                        isLoading: true,
                      ),
                    );
                  },
                )
              : messages.isEmpty 
              ? const Center(
                  child: Text(
                    'Halo! Saya asisten AI Hermina.\nApa yang bisa saya bantu hari ini?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isUser = msg['role'] == 'user';
                    final content = msg['content'] ?? '';
                    final isModelLoading = !isUser && content.toString().isEmpty;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ChatBubble(
                        text: content,
                        time: '', // You can format time if needed
                        isUser: isUser,
                        isLoading: isModelLoading,
                      ),
                    );
                  },
                ),
          ),
          const ChatInputArea(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -10,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset('assets/header_logo.png', width: 160),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hermina Hospital',
                          style: TextStyle(color: AppColors.textWhite, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tanyakan apa yang jadi keluhan kamu',
                          style: TextStyle(color: AppColors.textWhite, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                    onPressed: () {
                      ref.read(currentSessionIdProvider.notifier).state = null;
                      ref.read(chatMessagesProvider.notifier).clearMessages();
                    },
                    tooltip: 'New Chat',
                  ),
                  IconButton(
                    icon: const Icon(Icons.history, color: Colors.white),
                    onPressed: () => _showHistoryModal(context, ref),
                    tooltip: 'Chat History',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistoryModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final sessionsAsync = ref.watch(chatSessionsProvider);
            
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Riwayat Obrolan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: sessionsAsync.when(
                        data: (sessions) {
                          if (sessions.isEmpty) {
                            return const Center(child: Text('Belum ada riwayat.', style: TextStyle(color: AppColors.textGrey)));
                          }
                          return ListView.builder(
                            itemCount: sessions.length,
                            itemBuilder: (context, index) {
                              final session = sessions[index];
                              return Card(
                                elevation: 0,
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: Material(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: () {
                                      ref.read(chatMessagesProvider.notifier).loadSession(session['ID']);
                                      Navigator.pop(context);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      leading: const CircleAvatar(
                                        backgroundColor: AppColors.primaryLight,
                                        child: Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 20),
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              session['title'] ?? 'Percakapan Baru',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              ref.read(chatMessagesProvider.notifier).deleteSession(session['ID']);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const CardSkeletonLoader(count: 3),
                        error: (err, stack) => Center(child: Text(ErrorHandler.getMessage(err))),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
