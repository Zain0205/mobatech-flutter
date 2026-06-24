import 'package:flutter/material.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ChatAttachmentHandler {
  static Future<XFile?> pickImage(
    BuildContext context,
    ImageSource source,
    ImagePicker picker,
  ) async {
    Navigator.pop(context); // Close modal
    try {
      return await picker.pickImage(source: source);
    } catch (e) {
      if (context.mounted) {
        String errorMsg = 'Gagal membuka kamera/galeri. Pastikan izin akses diberikan dan perangkat mendukung fitur ini.';
        if (e.toString().contains('MissingPluginException')) {
          errorMsg = 'Fitur kamera/galeri tidak didukung pada simulator atau platform ini.';
        }
        
        CustomSnackbar.showError(context, errorMsg);
      }
      return null;
    }
  }

  static Future<FilePickerResult?> pickFile(BuildContext context) async {
    Navigator.pop(context); // Close modal
    try {
      return await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );
    } catch (e) {
      if (context.mounted) {
        String errorMsg = 'Gagal membuka pengelola berkas. Pastikan izin akses diberikan.';
        if (e.toString().contains('MissingPluginException') || e.toString().contains('Unsupported operation')) {
          errorMsg = 'Fitur lampiran dokumen tidak didukung pada simulator atau platform ini.';
        }
        
        CustomSnackbar.showError(context, errorMsg);
      }
      return null;
    }
  }
}
