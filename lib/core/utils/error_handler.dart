import 'package:dio/dio.dart';
import '../constants/app_strings.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error == null) return AppStrings.errUnknown;

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError) {
        return AppStrings.errConnection;
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
      return AppStrings.errSessionExpired;
    } else if (eLower.contains('unauthorized') || eLower.contains('403')) {
      return AppStrings.errUnauthorized;
    } else if (eLower.contains('validation_error') || eLower.contains('422')) {
      return AppStrings.errValidation;
    } else if (eLower.contains('not_found') || eLower.contains('404')) {
      return AppStrings.errNotFound;
    } else if (eLower.contains('conflict') || eLower.contains('409')) {
      return AppStrings.errConflict;
    } else if (eLower.contains('internal_error') || eLower.contains('500')) {
      return AppStrings.errServer;
    }

    if (eLower.contains('invalid credentials') ||
        eLower.contains('password salah') ||
        eLower.contains('user not found')) {
      return AppStrings.errInvalidCreds;
    } else if (eLower.contains('email already exists') ||
        eLower.contains('duplicate')) {
      return AppStrings.errEmailExists;
    }

    e = e.replaceAll('Exception:', '').replaceAll('Error:', '').trim();
    if (e.isEmpty) return AppStrings.errRequestFailed;
    if (e.length > 50) return AppStrings.errTimeout;

    return '${e[0].toUpperCase()}${e.substring(1)}';
  }
}
