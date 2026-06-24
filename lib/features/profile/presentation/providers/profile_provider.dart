import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? imagePath;
  final String? bloodType;
  final int? height;
  final int? weight;
  final String? allergies;
  final String? dob;
  final String? gender;
  final List<dynamic>? familyMembers;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.imagePath,
    this.bloodType,
    this.height,
    this.weight,
    this.allergies,
    this.dob,
    this.gender,
    this.familyMembers,
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
      bloodType: json['blood_type'],
      height: json['height'] != null
          ? int.tryParse(json['height'].toString())
          : null,
      weight: json['weight'] != null
          ? int.tryParse(json['weight'].toString())
          : null,
      allergies: json['allergies'],
      dob: json['date_of_birth'],
      gender: json['gender'],
      familyMembers: json['family_members'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phone,
      'imagePath': imagePath,
      'blood_type': bloodType,
      'height': height,
      'weight': weight,
      'allergies': allergies,
      'date_of_birth': dob,
      'gender': gender,
      'family_members': familyMembers,
    };
  }
}

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final userDataString = prefs.getString('user_data');
  if (userDataString != null) {
    final dynamic decoded = jsonDecode(userDataString);
    if (decoded is Map<String, dynamic>) {
      return UserProfile.fromJson(decoded);
    }
  }
  // Return null if there's no valid user data, forcing a re-login or empty state
  return null;
});
