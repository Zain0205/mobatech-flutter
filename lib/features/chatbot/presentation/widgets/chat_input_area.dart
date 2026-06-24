import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/chat_provider.dart';
import 'attachment_bottom_sheet.dart';
import 'attachment_preview.dart';
import 'suggestion_chips_row.dart';
import 'chat_input_row.dart';
import 'chat_attachment_handler.dart';

class ChatInputArea extends ConsumerStatefulWidget {
  const ChatInputArea({super.key});

  @override
  ConsumerState<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends ConsumerState<ChatInputArea> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  FilePickerResult? _selectedFile;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty && _selectedImage == null && _selectedFile == null) return;

    _controller.clear();

    final currentSessionId = ref.read(currentSessionIdProvider);
    final imgPath = _selectedImage?.path;
    final filePath = _selectedFile?.files.single.path;

    if (currentSessionId == null) {
      ref
          .read(chatMessagesProvider.notifier)
          .createNewSessionAndSend(
            text.isNotEmpty
                ? (text.length > 20 ? text.substring(0, 20) : text)
                : AppStrings.chatMediaAttachmentTitle,
            text,
            imagePath: imgPath,
            filePath: filePath,
          );
    } else {
      ref
          .read(chatMessagesProvider.notifier)
          .sendMessage(
            currentSessionId,
            text,
            imagePath: imgPath,
            filePath: filePath,
          );
    }

    setState(() {
      _selectedImage = null;
      _selectedFile = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await ChatAttachmentHandler.pickImage(
      context,
      source,
      _picker,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _selectedFile = null;
      });
    }
  }

  Future<void> _pickFile() async {
    final file = await ChatAttachmentHandler.pickFile(context);
    if (file != null) {
      setState(() {
        _selectedFile = file;
        _selectedImage = null;
      });
    }
  }

  void _showAttachmentModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return AttachmentBottomSheet(
          onPickGallery: () => _pickImage(ImageSource.gallery),
          onPickCamera: () => _pickImage(ImageSource.camera),
          onPickDocument: _pickFile,
        );
      },
    );
  }

  void _sendSuggestion(String text) {
    _controller.text = text;
    _sendMessage();
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
          AttachmentPreview(
            selectedImage: _selectedImage,
            selectedFile: _selectedFile,
            onRemove: () => setState(() {
              _selectedImage = null;
              _selectedFile = null;
            }),
          ),

          SuggestionChipsRow(onSuggestionTap: _sendSuggestion),
          const SizedBox(height: 12),
          ChatInputRow(
            controller: _controller,
            onSubmitted: _sendMessage,
            onAttachmentTap: _showAttachmentModal,
          ),
        ],
      ),
    );
  }
}
