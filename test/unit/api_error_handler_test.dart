import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:cat_app/core/errors/api_error_handler.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/core/network/local_status_codes.dart';

void main() {
  group('ApiErrorHandler', () {
    group('handle - DioException types', () {
      test('should handle connectionError correctly', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, contains('internet connection'));
        expect(result.icon, Icons.wifi_off);
        expect(result.statusCode, LocalStatusCodes.connectionError);
      });

      test('should handle connectionTimeout correctly', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, contains('took too long'));
        expect(result.icon, Icons.timer_off);
        expect(result.statusCode, LocalStatusCodes.connectionTimeout);
      });

      test('should handle sendTimeout correctly', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.sendTimeout,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, contains('timed out while sending'));
        expect(result.icon, Icons.send);
        expect(result.statusCode, LocalStatusCodes.sendTimeout);
      });

      test('should handle receiveTimeout correctly', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.receiveTimeout,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, contains('took too long to respond'));
        expect(result.icon, Icons.downloading);
        expect(result.statusCode, LocalStatusCodes.receiveTimeout);
      });

      test('should handle badCertificate correctly', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.badCertificate,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, contains('Security issue'));
        expect(result.icon, Icons.security);
        expect(result.statusCode, LocalStatusCodes.badCertificate);
      });

      test('should handle cancel correctly', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.cancel,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, contains('cancelled'));
        expect(result.icon, Icons.cancel);
        expect(result.statusCode, LocalStatusCodes.cancel);
      });

      test('should handle unknown type correctly', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.unknown,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, contains('Something went wrong'));
        expect(result.icon, Icons.error_outline);
        expect(result.statusCode, LocalStatusCodes.unknown);
      });
    });

    group('handleWithStatusCode', () {
      test('should handle 400 bad request', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'message': 'Validation failed'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 400);
        expect(result.message, 'Validation failed');
        expect(result.icon, Icons.warning);
      });

      test('should handle 401 unauthorized', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 401);
        expect(result.message, 'Unauthorized');
        expect(result.icon, Icons.lock);
      });

      test('should handle 403 forbidden', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 403,
            data: {'message': 'Forbidden'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 403);
        expect(result.message, 'Forbidden');
        expect(result.icon, Icons.block);
      });

      test('should handle 404 not found', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 404,
            data: {'message': 'Not found'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 404);
        expect(result.message, 'Not found');
        expect(result.icon, Icons.search_off);
      });

      test('should handle 409 conflict', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 409,
            data: {'message': 'Conflict'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 409);
        expect(result.message, 'Conflict');
        expect(result.icon, Icons.error_outline);
      });

      test('should handle 422 unprocessable entity', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 422,
            data: {'message': 'Unprocessable entity'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 422);
        expect(result.message, 'Unprocessable entity');
        expect(result.icon, Icons.warning_amber);
      });

      test('should handle 500 internal server error', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
            data: {'message': 'Server error'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 500);
        expect(result.message, 'Server error, please try again later');
        expect(result.icon, Icons.error);
      });

      test('should handle unknown status code with data', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 503,
            data: {'message': 'Service unavailable'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 503);
        expect(result.message, 'Service unavailable');
      });

      test('should handle unknown status code without data', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 418,
            data: null,
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 418);
        expect(result.message, 'Something went wrong. Please try again.');
      });

      test('should parse string response data', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: 'String error message',
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 400);
        expect(result.message, 'String error message');
        expect(result.icon, Icons.warning);
      });

      test('should parse errorMessage field from JSON', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'errorMessage': 'Error occurred'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, 'Error occurred');
      });

      test('should handle non-map, non-string response data', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: 12345,
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 400);
        expect(result.message, 'Server returned an error');
      });

      test('should handle parsing error gracefully', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'invalid': 'structure'},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 400);
      });
    });

    group('handle - non-DioException', () {
      test('should return default error for generic Exception', () {
        // arrange
        final exception = Exception('Generic error');

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, isNotEmpty);
      });

      test('should return default error for FormatException', () {
        // arrange
        final exception = FormatException('Invalid format');

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, isNotEmpty);
      });

      test('should return default error for TypeError', () {
        // arrange
        final exception = TypeError();

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, isNotEmpty);
      });

      test('should return default error for non-Exception', () {
        // arrange
        const error = 'String error';

        // act
        final result = ApiErrorHandler.handle(error);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, isNotEmpty);
      });
    });

    group('edge cases', () {
      test('should handle null response data', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
            data: null,
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 500);
        expect(result.message, 'Server error, please try again later');
      });

      test('should handle empty map response data', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {},
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 400);
      });

      test('should handle empty string response data', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: '',
          ),
          type: DioExceptionType.badResponse,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.statusCode, 400);
        expect(result.icon, Icons.warning);
      });

      test('should handle DioException without response', () {
        // arrange
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.unknown,
        );

        // act
        final result = ApiErrorHandler.handle(exception);

        // assert
        expect(result, isA<ApiErrorModel>());
        expect(result.message, contains('Something went wrong'));
      });

      test('should handle multiple error message formats', () {
        // Test cases for different JSON structures
        final testCases = [
          {
            'data': {'message': 'Error 1'},
            'expectedMessage': 'Error 1',
          },
          {
            'data': {'errorMessage': 'Error 2'},
            'expectedMessage': 'Error 2',
          },
          {
            'data': {'error': 'Error 3'},
            'expectedMessage': 'Unknown error',
          },
        ];

        for (final testCase in testCases) {
          // arrange
          final exception = DioException(
            requestOptions: RequestOptions(path: '/test'),
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 400,
              data: testCase['data'],
            ),
            type: DioExceptionType.badResponse,
          );

          // act
          final result = ApiErrorHandler.handle(exception);

          // assert
          expect(result, isA<ApiErrorModel>());
        }
      });

      test('should assign correct icon for each status code', () {
        // Test icon assignment for different status codes
        final testCases = {
          400: Icons.warning,
          401: Icons.lock,
          403: Icons.block,
          404: Icons.search_off,
          409: Icons.error_outline,
          422: Icons.warning_amber,
          500: Icons.error,
        };

        for (final entry in testCases.entries) {
          // arrange
          final exception = DioException(
            requestOptions: RequestOptions(path: '/test'),
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: entry.key,
              data: {'message': 'Test error'},
            ),
            type: DioExceptionType.badResponse,
          );

          // act
          final result = ApiErrorHandler.handle(exception);

          // assert
          expect(
            result.icon,
            entry.value,
            reason: 'Icon mismatch for status code ${entry.key}',
          );
        }
      });
    });
  });
}
