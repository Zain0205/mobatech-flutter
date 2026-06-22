import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';

class AttachmentPreview extends StatelessWidget {
  final XFile? selectedImage;
  final FilePickerResult? selectedFile;
  final VoidCallback onRemove;

  const AttachmentPreview({
    super.key,
    this.selectedImage,
    this.selectedFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedImage == null && selectedFile == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          if (selectedImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(selectedImage!.path),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
          else if (selectedFile != null)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.orange10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description, color: AppColors.iconOrange),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              selectedImage?.name ?? selectedFile?.files.single.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textGrey),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
