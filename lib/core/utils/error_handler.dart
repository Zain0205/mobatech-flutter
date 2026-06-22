class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error == null) return 'Terjadi kesalahan sistem yang tidak diketahui';
    
    String e = error.toString();
    String eLower = e.toLowerCase();

    // Industry Standard Exception Translation (from AGENTS.md)
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

    // Dio Exceptions and Network Errors
    if (eLower.contains('dioexception') || eLower.contains('network error') || eLower.contains('connection refused') || eLower.contains('timeout')) {
      return 'Koneksi ke server terputus. Pastikan internet Anda stabil atau server sedang aktif.';
    }
    
    // Auth specific (Firebase/Custom)
    if (eLower.contains('invalid credentials') || eLower.contains('password salah') || eLower.contains('user not found')) {
      return 'Email atau kata sandi tidak sesuai. Silakan periksa kembali.';
    } else if (eLower.contains('email already exists') || eLower.contains('duplicate')) {
      return 'Email ini sudah terdaftar. Gunakan email lain.';
    }
    
    // Clean raw exceptions before showing to user
    e = e.replaceAll('Exception:', '').replaceAll('Error:', '').trim();
    if (e.isEmpty) return 'Gagal memproses permintaan.';
    if (e.length > 50) return 'Gagal terhubung ke layanan (Error Timeout).';
    
    // Capitalize first letter
    return '${e[0].toUpperCase()}${e.substring(1)}';
  }
}
