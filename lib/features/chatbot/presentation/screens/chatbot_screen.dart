import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/chatbot_header.dart';
import '../widgets/chatbot_history_modal.dart';
import '../providers/chat_provider.dart';

class ChatbotScreen extends ConsumerWidget {
  const ChatbotScreen({super.key});

  void _showHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (_) => const ChatbotHistoryModal(),
    );
  }

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
              ChatbotHeader(onShowHistory: () => _showHistoryModal(context)),
              Expanded(
                child: isLoadingHistory
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ChatBubble(
                            text: '',
                            time: '',
                            isUser: index % 2 == 1,
                            isLoading: true,
                          ),
                        ),
                      )
                    : messages.isEmpty
                    ? const Center(
                        child: Text(
                          AppStrings.chatGreeting,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isUser = msg['role'] == 'user';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ChatBubble(
                              text: msg['content'] ?? '',
                              time: '',
                              isUser: isUser,
                              isLoading:
                                  !isUser &&
                                  (msg['content'] ?? '').toString().isEmpty,
                              imagePath: msg['imagePath'] as String?,
                              filePath: msg['filePath'] as String?,
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
}
