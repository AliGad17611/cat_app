import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cat_app/core/errors/api_error_factory.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/core/errors/dio_exception_type_extension.dart';
import 'package:cat_app/core/network/local_status_codes.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic e) {
    if (e is Exception) {
      if (e is DioException) {
        return e.when(
          connectionError: () => ApiErrorModel(
            message:
                "No internet connection. Please check your Wi-Fi or mobile data.",
            icon: Icons.wifi_off,
            statusCode: LocalStatusCodes.connectionError,
          ),
          connectionTimeout: () => ApiErrorModel(
            message:
                "The connection took too long. Try checking your internet or try again later.",
            icon: Icons.timer_off,
            statusCode: LocalStatusCodes.connectionTimeout,
          ),
          sendTimeout: () => ApiErrorModel(
            message: "Request timed out while sending data. Please try again.",
            icon: Icons.send,
            statusCode: LocalStatusCodes.sendTimeout,
          ),
          receiveTimeout: () => ApiErrorModel(
            message: "Server took too long to respond. Please try again later.",
            icon: Icons.downloading,
            statusCode: LocalStatusCodes.receiveTimeout,
          ),
          badCertificate: () => ApiErrorModel(
            message:
                "Security issue detected with the server. Connection not secure.",
            icon: Icons.security,
            statusCode: LocalStatusCodes.badCertificate,
          ),
          badResponse: () {
            // Use the new status code handling method
            return handleWithStatusCode(e);
          },
          cancel: () => ApiErrorModel(
            message: "The request was cancelled. Please try again.",
            icon: Icons.cancel,
            statusCode: LocalStatusCodes.cancel,
          ),
          unknown: () => ApiErrorModel(
            message:
                "Something went wrong. Please check your connection and try again.",
            icon: Icons.error_outline,
            statusCode: LocalStatusCodes.unknown,
          ),
        );
      }
    }
    return ApiErrorFactory.defaultError;
  }

  /// Handles DioException with status code switch pattern using ApiErrorModel
  static ApiErrorModel handleWithStatusCode(DioException e) {
    try {
      switch (e.response?.statusCode) {
        case 400: // Bad request - validation errors
          log('400 Bad Request: ${e.response!.data.toString()}');
          return _parseErrorResponse(e.response!.data, 400);

        case 401: // Unauthorized
          log('401 Unauthorized: ${e.response!.data.toString()}');
          return _parseErrorResponse(e.response!.data, 401);

        case 403: // Forbidden
          log('403 Forbidden: ${e.response!.data.toString()}');
          return _parseErrorResponse(e.response!.data, 403);

        case 404: // Not found
          log('404 Not Found: ${e.response!.data.toString()}');
          return _parseErrorResponse(e.response!.data, 404);

        case 409: // Conflict
          log('409 Conflict: ${e.response!.data.toString()}');
          return _parseErrorResponse(e.response!.data, 409);

        case 422: // Unprocessable entity
          log('422 Unprocessable Entity: ${e.response!.data.toString()}');
          return _parseErrorResponse(e.response!.data, 422);

        case 500: // Internal server error
          log('500 Internal Server Error');
          return ApiErrorModel(
            message: "Server error, please try again later",
            icon: Icons.error,
            statusCode: 500,
          );

        default: // Something went wrong
          log('Unknown error: Status ${e.response?.statusCode}');
          if (e.response?.data != null) {
            return _parseErrorResponse(
              e.response!.data,
              e.response?.statusCode,
            );
          } else {
            return ApiErrorModel(
              message: "Something went wrong. Please try again.",
              icon: Icons.error,
              statusCode: e.response?.statusCode ?? 0,
            );
          }
      }
    } catch (parseError) {
      log('Error parsing response: $parseError');
      return ApiErrorModel(
        message: "Error processing server response",
        icon: Icons.error,
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }

  /// Helper method to safely parse error response
  static ApiErrorModel _parseErrorResponse(dynamic data, int? statusCode) {
    try {
      if (data is Map<String, dynamic>) {
        return ApiErrorModel.fromJson(data);
      } else if (data is String) {
        return ApiErrorModel(
          message: data,
          icon: _getIconForStatusCode(statusCode),
          statusCode: statusCode,
        );
      } else {
        return ApiErrorModel(
          message: "Server returned an error",
          icon: _getIconForStatusCode(statusCode),
          statusCode: statusCode,
        );
      }
    } catch (e) {
      log('Failed to parse error response: $e');
      return ApiErrorModel(
        message: "Error processing server response",
        icon: Icons.error,
        statusCode: statusCode,
      );
    }
  }

  /// Helper method to get appropriate icon based on status code
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
}
