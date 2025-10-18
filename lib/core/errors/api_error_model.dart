import 'package:flutter/material.dart';

class ApiErrorModel {
  final int? statusCode;
  final String message;
  final IconData icon;

  ApiErrorModel({
    required this.message,
    required this.icon,
    required this.statusCode,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    // Handle server response format
    final message = json['message'] ?? json['errorMessage'] ?? 'Unknown error';
    final statusCode = json['statusCode'] is int
        ? json['statusCode']
        : (json['statusCode'] is String
              ? int.tryParse(json['statusCode'])
              : null);
    return ApiErrorModel(
      message: message,
      icon: _getIconForStatusCode(statusCode),
      statusCode: statusCode,
    );

  }
  // Helper method to get appropriate icon based on status code
  static IconData _getIconForStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return Icons.warning; // Bad request - validation errors
      case 401:
        return Icons.lock; // Unauthorized
      case 403:
        return Icons.block; // Forbidden
      case 404:
        return Icons.search_off; // Not found
      case 409:
        return Icons.error_outline; // Conflict
      case 422:
        return Icons.warning_amber; // Unprocessable entity
      case 500:
        return Icons.error; // Server error
      default:
        return Icons.error; // Default error icon
    }
  }


  /// Check if this is a validation error (400 status code)
  bool get isValidationError => statusCode == 400;


  /// Check if this is a server error (5xx status codes)
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Get a user-friendly error title based on status code
  String get errorTitle {
    switch (statusCode) {
      case 400:
        return 'Validation Error';
      case 401:
        return 'Authentication Required';
      case 403:
        return 'Access Denied';
      case 404:
        return 'Not Found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Invalid Data';
      case 500:
        return 'Server Error';
      default:
        return 'Error';
    }
  }

  @override
  String toString() {
    return 'ApiErrorModel(statusCode: $statusCode, message: $message, )';
  }
}
