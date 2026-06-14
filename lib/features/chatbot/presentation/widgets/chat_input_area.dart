import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'suggestion_chip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';

class ChatInputArea extends ConsumerStatefulWidget {
  const ChatInputArea({super.key});

  @override
  ConsumerState<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends ConsumerState<ChatInputArea> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    
    final currentSessionId = ref.read(currentSessionIdProvider);
    if (currentSessionId == null) {
      // Create a new session with the first message as title
      ref.read(chatMessagesProvider.notifier).createNewSessionAndSend(
        text.length > 20 ? text.substring(0, 20) : text,
        text,
      );
    } else {
      ref.read(chatMessagesProvider.notifier).sendMessage(currentSessionId, text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: AppColors.backgroundScreen,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.text = 'Cek Gejala';
                    _sendMessage();
                  },
                  child: const SuggestionChip(icon: Icons.medical_services_outlined, label: 'Cek Gejala')
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _controller.text = 'Info Jadwal Dokter';
                    _sendMessage();
                  },
                  child: const SuggestionChip(icon: Icons.calendar_month_outlined, label: 'Info Jadwal Dokter')
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _controller.text = 'Fasilitas Hermina';
                    _sendMessage();
                  },
                  child: const SuggestionChip(icon: Icons.local_hospital_outlined, label: 'Fasilitas Hermina')
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: const InputDecoration(
                            hintText: 'Tulis Pertanyaan Kamu Disini ...',
                            hintStyle: TextStyle(fontSize: 13, color: AppColors.textGrey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.attach_file, color: AppColors.textGrey, size: 20),
                      const SizedBox(width: 12),
                      const Icon(Icons.camera_alt_outlined, color: AppColors.textGrey, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: AppColors.textWhite, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
