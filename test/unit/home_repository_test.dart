import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/features/home/data/datasources/home_api_service.dart';
import 'package:cat_app/features/home/data/repositories/home_repository.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:cat_app/features/home/data/models/weight_model.dart';

@GenerateMocks([HomeApiService])
import 'home_repository_test.mocks.dart';

void main() {
  late HomeRepository repository;
  late MockHomeApiService mockApiService;

  setUp(() {
    mockApiService = MockHomeApiService();
    repository = HomeRepository(mockApiService);
  });

  group('HomeRepository', () {
    group('getBreeds', () {
      final tBreedsList = [
        BreedModel(
          weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
          id: 'abys',
          name: 'Abyssinian',
          description: 'Test description',
          lifeSpan: '14 - 15',
          origin: 'Egypt',
          temperament: 'Active, Energetic',
          referenceImageId: '0XYvRd7oD',
        ),
      ];

      test(
        'should return list of breeds when API call is successful',
        () async {
          // arrange
          when(
            mockApiService.getBreeds(any, any),
          ).thenAnswer((_) async => tBreedsList);

          // act
          final result = await repository.getBreeds(page: 0, limit: 20);

          // assert
          expect(result, equals(tBreedsList));
          verify(mockApiService.getBreeds(20, 0)).called(1);
          verifyNoMoreInteractions(mockApiService);
        },
      );

      test('should return empty list when API returns empty list', () async {
        // arrange
        when(mockApiService.getBreeds(any, any)).thenAnswer((_) async => []);

        // act
        final result = await repository.getBreeds(page: 5, limit: 20);

        // assert
        expect(result, equals([]));
        verify(mockApiService.getBreeds(20, 5)).called(1);
      });

      test('should use default pagination values when not provided', () async {
        // arrange
        when(
          mockApiService.getBreeds(any, any),
        ).thenAnswer((_) async => tBreedsList);

        // act
        final result = await repository.getBreeds();

        // assert
        expect(result, equals(tBreedsList));
        verify(mockApiService.getBreeds(20, 0)).called(1);
      });

      test('should throw ApiErrorModel when DioException occurs', () async {
        // arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          response: Response(
            requestOptions: RequestOptions(path: '/breeds'),
            statusCode: 500,
            data: {'message': 'Server error'},
          ),
          type: DioExceptionType.badResponse,
        );
        when(mockApiService.getBreeds(any, any)).thenThrow(dioException);

        // act & assert
        expect(
          () => repository.getBreeds(page: 0, limit: 20),
          throwsA(isA<ApiErrorModel>()),
        );
      });

      test(
        'should throw ApiErrorModel with correct message for connection error',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/breeds'),
            type: DioExceptionType.connectionError,
          );
          when(mockApiService.getBreeds(any, any)).thenThrow(dioException);

          // act & assert
          try {
            await repository.getBreeds(page: 0, limit: 20);
            fail('Should throw ApiErrorModel');
          } catch (e) {
            expect(e, isA<ApiErrorModel>());
            final error = e as ApiErrorModel;
            expect(error.message, contains('internet connection'));
          }
        },
      );

      test('should throw ApiErrorModel for connection timeout', () async {
        // arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.connectionTimeout,
        );
        when(mockApiService.getBreeds(any, any)).thenThrow(dioException);

        // act & assert
        try {
          await repository.getBreeds(page: 0, limit: 20);
          fail('Should throw ApiErrorModel');
        } catch (e) {
          expect(e, isA<ApiErrorModel>());
          final error = e as ApiErrorModel;
          expect(error.message, contains('took too long'));
        }
      });

      test(
        'should throw ApiErrorModel with 404 status code and message',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/breeds'),
            response: Response(
              requestOptions: RequestOptions(path: '/breeds'),
              statusCode: 404,
              data: {'message': 'Not found'},
            ),
            type: DioExceptionType.badResponse,
          );
          when(mockApiService.getBreeds(any, any)).thenThrow(dioException);

          // act & assert
          try {
            await repository.getBreeds(page: 0, limit: 20);
            fail('Should throw ApiErrorModel');
          } catch (e) {
            expect(e, isA<ApiErrorModel>());
            final error = e as ApiErrorModel;
            expect(error.statusCode, 404);
            expect(error.message, 'Not found');
            expect(error.icon, Icons.search_off);
          }
        },
      );

      test(
        'should throw ApiErrorModel with 401 status code and message',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/breeds'),
            response: Response(
              requestOptions: RequestOptions(path: '/breeds'),
              statusCode: 401,
              data: {'message': 'Unauthorized'},
            ),
            type: DioExceptionType.badResponse,
          );
          when(mockApiService.getBreeds(any, any)).thenThrow(dioException);

          // act & assert
          try {
            await repository.getBreeds(page: 0, limit: 20);
            fail('Should throw ApiErrorModel');
          } catch (e) {
            expect(e, isA<ApiErrorModel>());
            final error = e as ApiErrorModel;
            expect(error.statusCode, 401);
            expect(error.message, 'Unauthorized');
            expect(error.icon, Icons.lock);
          }
        },
      );

      test('should throw ApiErrorModel for generic exception', () async {
        // arrange
        when(
          mockApiService.getBreeds(any, any),
        ).thenThrow(Exception('Generic error'));

        // act & assert
        expect(
          () => repository.getBreeds(page: 0, limit: 20),
          throwsA(isA<ApiErrorModel>()),
        );
      });

      test('should pass correct page and limit to API service', () async {
        // arrange
        when(
          mockApiService.getBreeds(any, any),
        ).thenAnswer((_) async => tBreedsList);

        // act
        await repository.getBreeds(page: 3, limit: 10);

        // assert
        verify(mockApiService.getBreeds(10, 3)).called(1);
      });
    });
  });
}
