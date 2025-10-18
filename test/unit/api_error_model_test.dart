import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/core/errors/api_error_model.dart';

void main() {
  group('ApiErrorModel', () {
    group('fromJson', () {
      test('should parse simple error message', () {
        final json = {'message': 'Something went wrong', 'statusCode': 400};

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Something went wrong');
        expect(result.statusCode, 400);
        expect(result.errors, isNotEmpty);
        expect(result.icon, Icons.warning);
      });

      test('should parse error with errorMessage field', () {
        final json = {'errorMessage': 'Error occurred', 'statusCode': 500};

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Error occurred');
        expect(result.statusCode, 500);
      });

      test('should parse error with list of errors', () {
        final json = {
          'message': 'Validation failed',
          'statusCode': 400,
          'errors': ['Error 1', 'Error 2', 'Error 3'],
        };

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Validation failed');
        expect(result.statusCode, 400);
        expect(result.errors.length, 3);
        expect(result.errors, contains('Error 1'));
        expect(result.errors, contains('Error 2'));
        expect(result.errors, contains('Error 3'));
      });

      test('should parse error with map of errors', () {
        final json = {
          'message': 'Validation failed',
          'statusCode': 422,
          'errors': {
            'email': ['Email is required', 'Email must be valid'],
            'password': ['Password is too short'],
          },
        };

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Validation failed');
        expect(result.statusCode, 422);
        expect(result.errors.length, 3);
        expect(result.errors, contains('Email is required'));
        expect(result.errors, contains('Email must be valid'));
        expect(result.errors, contains('Password is too short'));
      });

      test('should parse statusCode as string', () {
        final json = {'message': 'Error', 'statusCode': '404'};

        final result = ApiErrorModel.fromJson(json);

        expect(result.statusCode, 404);
      });

      test('should handle data.message format', () {
        final json = {
          'message': 'Error',
          'statusCode': 400,
          'data': {'message': 'Detailed error message'},
        };

        final result = ApiErrorModel.fromJson(json);

        expect(result.errors, contains('Detailed error message'));
      });

      test('should return default message for empty json', () {
        final json = <String, dynamic>{};

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Unknown error');
      });

      test('should set correct icon for 401 status code', () {
        final json = {'message': 'Unauthorized', 'statusCode': 401};

        final result = ApiErrorModel.fromJson(json);

        expect(result.icon, Icons.lock);
      });

      test('should set correct icon for 403 status code', () {
        final json = {'message': 'Forbidden', 'statusCode': 403};

        final result = ApiErrorModel.fromJson(json);

        expect(result.icon, Icons.block);
      });

      test('should set correct icon for 404 status code', () {
        final json = {'message': 'Not found', 'statusCode': 404};

        final result = ApiErrorModel.fromJson(json);

        expect(result.icon, Icons.search_off);
      });

      test('should set correct icon for 409 status code', () {
        final json = {'message': 'Conflict', 'statusCode': 409};

        final result = ApiErrorModel.fromJson(json);

        expect(result.icon, Icons.error_outline);
      });

      test('should set correct icon for 500 status code', () {
        final json = {'message': 'Server error', 'statusCode': 500};

        final result = ApiErrorModel.fromJson(json);

        expect(result.icon, Icons.error);
      });
    });

    group('getter methods', () {
      test('firstError should return first error from list', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 400,
          icon: Icons.error,
          errors: ['First error', 'Second error'],
        );

        expect(error.firstError, 'First error');
      });

      test('firstError should return message when errors list is empty', () {
        final error = ApiErrorModel(
          message: 'Main error message',
          statusCode: 400,
          icon: Icons.error,
          errors: [],
        );

        expect(error.firstError, 'Main error message');
      });

      test('allErrorsAsString should join all errors with newline', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 400,
          icon: Icons.error,
          errors: ['Error 1', 'Error 2', 'Error 3'],
        );

        expect(error.allErrorsAsString, 'Error 1\nError 2\nError 3');
      });

      test('isValidationError should return true for 400 status code', () {
        final error = ApiErrorModel(
          message: 'Validation error',
          statusCode: 400,
          icon: Icons.warning,
          errors: [],
        );

        expect(error.isValidationError, true);
      });

      test('isValidationError should return false for non-400 status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 500,
          icon: Icons.error,
          errors: [],
        );

        expect(error.isValidationError, false);
      });

      test('isAuthError should return true for 401 status code', () {
        final error = ApiErrorModel(
          message: 'Unauthorized',
          statusCode: 401,
          icon: Icons.lock,
          errors: [],
        );

        expect(error.isAuthError, true);
      });

      test('isAuthError should return false for non-401 status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 400,
          icon: Icons.warning,
          errors: [],
        );

        expect(error.isAuthError, false);
      });

      test('isServerError should return true for 500 status code', () {
        final error = ApiErrorModel(
          message: 'Server error',
          statusCode: 500,
          icon: Icons.error,
          errors: [],
        );

        expect(error.isServerError, true);
      });

      test('isServerError should return true for 503 status code', () {
        final error = ApiErrorModel(
          message: 'Service unavailable',
          statusCode: 503,
          icon: Icons.error,
          errors: [],
        );

        expect(error.isServerError, true);
      });

      test('isServerError should return false for non-5xx status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 400,
          icon: Icons.warning,
          errors: [],
        );

        expect(error.isServerError, false);
      });
    });

    group('errorTitle', () {
      test('should return correct title for 400', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 400,
          icon: Icons.warning,
          errors: [],
        );

        expect(error.errorTitle, 'Validation Error');
      });

      test('should return correct title for 401', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 401,
          icon: Icons.lock,
          errors: [],
        );

        expect(error.errorTitle, 'Authentication Required');
      });

      test('should return correct title for 403', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 403,
          icon: Icons.block,
          errors: [],
        );

        expect(error.errorTitle, 'Access Denied');
      });

      test('should return correct title for 404', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 404,
          icon: Icons.search_off,
          errors: [],
        );

        expect(error.errorTitle, 'Not Found');
      });

      test('should return correct title for 409', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 409,
          icon: Icons.error_outline,
          errors: [],
        );

        expect(error.errorTitle, 'Conflict');
      });

      test('should return correct title for 422', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 422,
          icon: Icons.warning_amber,
          errors: [],
        );

        expect(error.errorTitle, 'Invalid Data');
      });

      test('should return correct title for 500', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 500,
          icon: Icons.error,
          errors: [],
        );

        expect(error.errorTitle, 'Server Error');
      });

      test('should return default title for unknown status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 999,
          icon: Icons.error,
          errors: [],
        );

        expect(error.errorTitle, 'Error');
      });
    });

    test('toString should return formatted string', () {
      final error = ApiErrorModel(
        message: 'Test error',
        statusCode: 400,
        icon: Icons.warning,
        errors: ['Error 1'],
      );

      final result = error.toString();

      expect(result, contains('400'));
      expect(result, contains('Test error'));
      expect(result, contains('Error 1'));
    });
  });
}
