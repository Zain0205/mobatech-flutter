class Formatters {
  static String formatPhoneNumber(String phone) {
    // Clean all non-digit characters except the leading plus
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If it doesn't start with +62, but starts with 0 or 62, normalize it to +62
    if (!cleanPhone.startsWith('+62')) {
      if (cleanPhone.startsWith('62')) {
        cleanPhone = '+62${cleanPhone.substring(2)}';
      } else if (cleanPhone.startsWith('0')) {
        cleanPhone = '+62${cleanPhone.substring(1)}';
      }
    }

    // Now format: +62 812-3456-7890
    if (cleanPhone.startsWith('+62')) {
      String localPart = cleanPhone.substring(3);
      if (localPart.length > 3) {
        String p1 = localPart.substring(0, 3); // 812
        String remainder = localPart.substring(3); // 34567890
        
        if (remainder.length > 4) {
          String p2 = remainder.substring(0, 4); // 3456
          String p3 = remainder.substring(4); // 7890
          return '+62 $p1-$p2-$p3';
        } else {
          return '+62 $p1-$remainder';
        }
      } else if (localPart.isNotEmpty) {
        return '+62 $localPart';
      }
    }
    return cleanPhone; // Fallback
  }
}
