import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../../../core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(ref.watch(dioProvider));
});

final authStateProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(false);

  Future<void> login(String email, String password) async {
    state = true;
    try {
      final res = await _repository.login(email, password);
      globalAuthToken = res['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', globalAuthToken!);
      await prefs.setString('user_data', jsonEncode(res['user']));
    } finally {
      state = false;
    }
  }

  Future<void> register(String fullName, String email, String phone, String password) async {
    state = true;
    try {
      await _repository.register(fullName, email, phone, password);
      // Wait, let's login right after register!
      final loginRes = await _repository.login(email, password);
      globalAuthToken = loginRes['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', globalAuthToken!);
      await prefs.setString('user_data', jsonEncode(loginRes['user']));
    } finally {
      state = false;
    }
  }

  Future<void> updateProfile(String fullName, String phone, String? imagePath) async {
    state = true;
    try {
      final res = await _repository.updateProfile(fullName, phone, imagePath);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(res['user']));
    } finally {
      state = false;
    }
  }
}
