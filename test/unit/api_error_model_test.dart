import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/core/errors/api_error_model.dart';

void main() {
  group('ApiErrorModel', () {
    group('constructor', () {
      test('should create instance with all required fields', () {
        final error = ApiErrorModel(
          message: 'Test error',
          statusCode: 400,
          icon: Icons.warning,
        );

        expect(error.message, 'Test error');
        expect(error.statusCode, 400);
        expect(error.icon, Icons.warning);
      });

      test('should create instance with null status code', () {
        final error = ApiErrorModel(
          message: 'Test error',
          statusCode: null,
          icon: Icons.error,
        );

        expect(error.message, 'Test error');
        expect(error.statusCode, null);
        expect(error.icon, Icons.error);
      });
    });

    group('fromJson', () {
      test('should parse simple error message', () {
        final json = {'message': 'Something went wrong', 'statusCode': 400};

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Something went wrong');
        expect(result.statusCode, 400);
        expect(result.icon, Icons.warning);
      });

      test('should parse error with errorMessage field', () {
        final json = {'errorMessage': 'Error occurred', 'statusCode': 500};

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Error occurred');
        expect(result.statusCode, 500);
        expect(result.icon, Icons.error);
      });

      test('should parse statusCode as string', () {
        final json = {'message': 'Error', 'statusCode': '404'};

        final result = ApiErrorModel.fromJson(json);

        expect(result.statusCode, 404);
        expect(result.icon, Icons.search_off);
      });

      test('should return default message for empty json', () {
        final json = <String, dynamic>{};

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Unknown error');
        expect(result.icon, Icons.error);
      });

      test('should handle null statusCode in json', () {
        final json = {'message': 'Error', 'statusCode': null};

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Error');
        expect(result.statusCode, null);
        expect(result.icon, Icons.error);
      });

      test('should prefer message over errorMessage', () {
        final json = {
          'message': 'Primary message',
          'errorMessage': 'Secondary message',
          'statusCode': 400,
        };

        final result = ApiErrorModel.fromJson(json);

        expect(result.message, 'Primary message');
      });
    });

    group('icon assignment by status code', () {
      test('should set warning icon for 400 status code', () {
        final json = {'message': 'Bad Request', 'statusCode': 400};
        final result = ApiErrorModel.fromJson(json);
        expect(result.icon, Icons.warning);
      });

      test('should set lock icon for 401 status code', () {
        final json = {'message': 'Unauthorized', 'statusCode': 401};
        final result = ApiErrorModel.fromJson(json);
        expect(result.icon, Icons.lock);
      });

      test('should set block icon for 403 status code', () {
        final json = {'message': 'Forbidden', 'statusCode': 403};
        final result = ApiErrorModel.fromJson(json);
        expect(result.icon, Icons.block);
      });

      test('should set search_off icon for 404 status code', () {
        final json = {'message': 'Not found', 'statusCode': 404};
        final result = ApiErrorModel.fromJson(json);
        expect(result.icon, Icons.search_off);
      });

      test('should set error_outline icon for 409 status code', () {
        final json = {'message': 'Conflict', 'statusCode': 409};
        final result = ApiErrorModel.fromJson(json);
        expect(result.icon, Icons.error_outline);
      });

      test('should set warning_amber icon for 422 status code', () {
        final json = {'message': 'Unprocessable Entity', 'statusCode': 422};
        final result = ApiErrorModel.fromJson(json);
        expect(result.icon, Icons.warning_amber);
      });

      test('should set error icon for 500 status code', () {
        final json = {'message': 'Server error', 'statusCode': 500};
        final result = ApiErrorModel.fromJson(json);
        expect(result.icon, Icons.error);
      });

      test('should set default error icon for unknown status code', () {
        final json = {'message': 'Error', 'statusCode': 999};
        final result = ApiErrorModel.fromJson(json);
        expect(result.icon, Icons.error);
      });
    });

    group('isValidationError getter', () {
      test('should return true for 400 status code', () {
        final error = ApiErrorModel(
          message: 'Validation error',
          statusCode: 400,
          icon: Icons.warning,
        );

        expect(error.isValidationError, true);
      });

      test('should return false for non-400 status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 500,
          icon: Icons.error,
        );

        expect(error.isValidationError, false);
      });

      test('should return false for null status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: null,
          icon: Icons.error,
        );

        expect(error.isValidationError, false);
      });
    });

    group('isServerError getter', () {
      test('should return true for 500 status code', () {
        final error = ApiErrorModel(
          message: 'Server error',
          statusCode: 500,
          icon: Icons.error,
        );

        expect(error.isServerError, true);
      });

      test('should return true for 503 status code', () {
        final error = ApiErrorModel(
          message: 'Service unavailable',
          statusCode: 503,
          icon: Icons.error,
        );

        expect(error.isServerError, true);
      });

      test('should return true for any 5xx status code', () {
        final error = ApiErrorModel(
          message: 'Gateway error',
          statusCode: 502,
          icon: Icons.error,
        );

        expect(error.isServerError, true);
      });

      test('should return false for non-5xx status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 400,
          icon: Icons.warning,
        );

        expect(error.isServerError, false);
      });

      test('should return false for null status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: null,
          icon: Icons.error,
        );

        expect(error.isServerError, false);
      });
    });

    group('errorTitle getter', () {
      test('should return correct title for 400', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 400,
          icon: Icons.warning,
        );

        expect(error.errorTitle, 'Validation Error');
      });

      test('should return correct title for 401', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 401,
          icon: Icons.lock,
        );

        expect(error.errorTitle, 'Authentication Required');
      });

      test('should return correct title for 403', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 403,
          icon: Icons.block,
        );

        expect(error.errorTitle, 'Access Denied');
      });

      test('should return correct title for 404', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 404,
          icon: Icons.search_off,
        );

        expect(error.errorTitle, 'Not Found');
      });

      test('should return correct title for 409', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 409,
          icon: Icons.error_outline,
        );

        expect(error.errorTitle, 'Conflict');
      });

      test('should return correct title for 422', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 422,
          icon: Icons.warning_amber,
        );

        expect(error.errorTitle, 'Invalid Data');
      });

      test('should return correct title for 500', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 500,
          icon: Icons.error,
        );

        expect(error.errorTitle, 'Server Error');
      });

      test('should return default title for unknown status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: 999,
          icon: Icons.error,
        );

        expect(error.errorTitle, 'Error');
      });

      test('should return default title for null status code', () {
        final error = ApiErrorModel(
          message: 'Error',
          statusCode: null,
          icon: Icons.error,
        );

        expect(error.errorTitle, 'Error');
      });
    });

    group('toString', () {
      test('should return formatted string with all fields', () {
        final error = ApiErrorModel(
          message: 'Test error',
          statusCode: 400,
          icon: Icons.warning,
        );

        final result = error.toString();

        expect(result, contains('400'));
        expect(result, contains('Test error'));
        expect(result, contains('ApiErrorModel'));
      });

      test('should handle null status code in toString', () {
        final error = ApiErrorModel(
          message: 'Test error',
          statusCode: null,
          icon: Icons.error,
        );

        final result = error.toString();

        expect(result, contains('null'));
        expect(result, contains('Test error'));
      });
    });
  });
}
