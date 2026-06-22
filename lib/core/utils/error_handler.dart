import 'package:dio/dio.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error == null) return 'Terjadi kesalahan sistem yang tidak diketahui';
    
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout || 
          error.type == DioExceptionType.receiveTimeout || 
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError) {
        return 'Koneksi ke server terputus. Pastikan internet Anda stabil atau server sedang aktif.';
      }
      
      if (error.response?.data != null) {
        final data = error.response!.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('errors') && data['errors'] != null) {
            final errors = data['errors'] as Map<String, dynamic>;
            if (errors.isNotEmpty) {
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                return firstError.first.toString();
              }
            }
          }
          if (data.containsKey('message')) {
            return data['message'].toString();
          }
          if (data.containsKey('error')) {
            return data['error'].toString();
          }
        }
      }
    }

    String e = error.toString();
    String eLower = e.toLowerCase();

    if (eLower.contains('unauthenticated') || eLower.contains('401')) {
      return 'Sesi Anda telah habis. Silakan login kembali.';
    } else if (eLower.contains('unauthorized') || eLower.contains('403')) {
      return 'Anda tidak memiliki akses ke fitur ini.';
    } else if (eLower.contains('validation_error') || eLower.contains('422')) {
      return 'Format data yang Anda masukkan tidak valid.';
    } else if (eLower.contains('not_found') || eLower.contains('404')) {
      return 'Data tidak ditemukan.';
    } else if (eLower.contains('conflict') || eLower.contains('409')) {
      return 'Terjadi duplikasi data atau konflik.';
    } else if (eLower.contains('internal_error') || eLower.contains('500')) {
      return 'Terjadi kesalahan pada server. Coba beberapa saat lagi.';
    }

    if (eLower.contains('invalid credentials') || eLower.contains('password salah') || eLower.contains('user not found')) {
      return 'Email atau kata sandi tidak sesuai. Silakan periksa kembali.';
    } else if (eLower.contains('email already exists') || eLower.contains('duplicate')) {
      return 'Email ini sudah terdaftar. Gunakan email lain.';
    }
    
    e = e.replaceAll('Exception:', '').replaceAll('Error:', '').trim();
    if (e.isEmpty) return 'Gagal memproses permintaan.';
    if (e.length > 50) return 'Gagal terhubung ke layanan (Error Timeout).';
    
    return '${e[0].toUpperCase()}${e.substring(1)}';
  }
}
