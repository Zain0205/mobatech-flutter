import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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
        text.isNotEmpty ? (text.length > 20 ? text.substring(0, 20) : text) : 'Berkas Media',
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Akses ditolak atau dibatalkan.')));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memilih file.')));
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
          // Attachment Preview Area
          if (_selectedImage != null || _selectedFile != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryLight),
              ),
              child: Row(
                children: [
                  if (_selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(_selectedImage!.path), width: 50, height: 50, fit: BoxFit.cover),
                    )
                  else if (_selectedFile != null)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.description, color: Colors.orange),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedImage?.name ?? _selectedFile?.files.single.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textGrey),
                    onPressed: () => setState(() {
                      _selectedImage = null;
                      _selectedFile = null;
                    }),
                  ),
                ],
              ),
            ),
          
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
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
                          GestureDetector(
                            onTap: () => _showAttachmentModal(context),
                            child: const Icon(Icons.attach_file, color: AppColors.textGrey, size: 20),
                          ),
                        ],
                      ),
                    ),
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

  void _showAttachmentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.dividerGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentOption(Icons.image, 'Galeri', Colors.blue, () => _pickImage(ImageSource.gallery)),
                  _buildAttachmentOption(Icons.camera_alt, 'Kamera', Colors.green, () => _pickImage(ImageSource.camera)),
                  _buildAttachmentOption(Icons.description, 'Dokumen', Colors.orange, _pickFile),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
        ],
      ),
    );
  }
}
