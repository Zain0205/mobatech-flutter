class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error == null) return 'Terjadi kesalahan sistem yang tidak diketahui';
    
    String e = error.toString();
    String eLower = e.toLowerCase();

    // Industry Standard Exception Translation
    if (eLower.contains('invalid credentials') || eLower.contains('password salah') || eLower.contains('user not found')) {
      return 'Email atau kata sandi tidak sesuai. Silakan periksa kembali.';
    } else if (eLower.contains('email already exists') || eLower.contains('duplicate')) {
      return 'Email ini sudah terdaftar. Gunakan email lain atau silakan Login.';
    } else if (eLower.contains('network error') || eLower.contains('connection refused') || eLower.contains('timeout')) {
      return 'Koneksi ke server terputus. Pastikan internet Anda stabil.';
    } else if (eLower.contains('unauthorized') || eLower.contains('token expired')) {
      return 'Sesi Anda telah habis demi keamanan. Silakan login kembali.';
    } else if (eLower.contains('format')) {
      return 'Format data yang Anda masukkan tidak valid.';
    }
    
    // Clean raw exceptions before showing to user
    e = e.replaceAll('Exception:', '').replaceAll('Error:', '').trim();
    if (e.isEmpty) return 'Gagal memproses permintaan.';
    
    // Capitalize first letter
    return '${e[0].toUpperCase()}${e.substring(1)}';
  }
}
