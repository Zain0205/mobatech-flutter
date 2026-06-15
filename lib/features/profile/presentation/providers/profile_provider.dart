import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? imagePath;

  UserProfile({
    required this.id, 
    required this.fullName, 
    required this.email, 
    required this.phone,
    this.imagePath,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    String? imgPath = json['image_url'] ?? json['imagePath'];
    if (imgPath != null && imgPath.trim().isEmpty) {
      imgPath = null;
    }
    return UserProfile(
      id: json['ID'] ?? 0,
      fullName: json['full_name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone_number'] ?? json['phone'] ?? '',
      imagePath: imgPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phone,
      'imagePath': imagePath,
    };
  }
}

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final userDataString = prefs.getString('user_data');
  if (userDataString != null) {
    final Map<String, dynamic> json = jsonDecode(userDataString);
    return UserProfile.fromJson(json);
  }
  // Fallback for current session where user logged in before this update
  return UserProfile(
    id: 1, 
    fullName: "Bang Rico", 
    email: "rico@example.com", 
    phone: "08123456789"
  );
});
