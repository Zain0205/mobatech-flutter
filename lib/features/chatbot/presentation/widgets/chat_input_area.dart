import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/chat_provider.dart';
import 'attachment_bottom_sheet.dart';
import 'attachment_preview.dart';
import 'chat_text_field.dart';
import 'suggestion_chips_row.dart';

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
      ref.read(chatMessagesProvider.notifier).createNewSessionAndSend(
        text.isNotEmpty ? (text.length > 20 ? text.substring(0, 20) : text) : AppStrings.chatMediaAttachmentTitle,
        text,
        imagePath: imgPath,
        filePath: filePath,
      );
    } else {
      ref.read(chatMessagesProvider.notifier).sendMessage(
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
    Navigator.pop(context); // Close modal
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _selectedFile = null;
        });
      }
    } catch (e) {
      setState(() {
        _selectedImage = XFile('assets/doctor.png');
        _selectedFile = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.chatBypassImageMsg)));
      }
    }
  }

  Future<void> _pickFile() async {
    Navigator.pop(context); // Close modal
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );
      if (result != null) {
        setState(() {
          _selectedFile = result;
          _selectedImage = null;
        });
      }
    } catch (e) {
      setState(() {
        _selectedFile = FilePickerResult([PlatformFile(path: 'dummy_document.pdf', name: 'dummy_document.pdf', size: 1024)]);
        _selectedImage = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.chatBypassFileMsg)));
      }
    }
  }

  void _showAttachmentModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
          Row(
            children: [
              Expanded(
                child: ChatTextField(
                  controller: _controller,
                  onSubmitted: _sendMessage,
                  onAttachmentTap: _showAttachmentModal,
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
