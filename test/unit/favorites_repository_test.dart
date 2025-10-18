import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/features/favorites/data/datasources/favorites_api_service.dart';
import 'package:cat_app/features/favorites/data/repositories/favorites_repository.dart';
import 'package:cat_app/features/favorites/data/models/favorite_model.dart';

@GenerateMocks([FavoritesApiService])
import 'favorites_repository_test.mocks.dart';

void main() {
  late FavoritesRepository repository;
  late MockFavoritesApiService mockApiService;

  setUp(() {
    mockApiService = MockFavoritesApiService();
    repository = FavoritesRepository(mockApiService);
  });

  group('FavoritesRepository', () {
    group('getFavorites', () {
      final tFavoritesList = [
        FavoriteModel(
          id: 1,
          imageId: 'img1',
          subId: 'user123',
          createdAt: '2024-01-01T00:00:00Z',
          image: FavoriteImageModel(
            id: 'img1',
            url: 'https://example.com/img1.jpg',
          ),
        ),
        FavoriteModel(
          id: 2,
          imageId: 'img2',
          subId: 'user123',
          createdAt: '2024-01-02T00:00:00Z',
          image: FavoriteImageModel(
            id: 'img2',
            url: 'https://example.com/img2.jpg',
          ),
        ),
      ];

      test(
        'should return Right with list of favorites when API call is successful',
        () async {
          // arrange
          when(
            mockApiService.getFavorites(
              attachImage: anyNamed('attachImage'),
              subId: anyNamed('subId'),
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => tFavoritesList);

          // act
          final result = await repository.getFavorites(
            subId: 'user123',
            attachImage: true,
            order: 'DESC',
          );

          // assert
          expect(result, equals(Right(tFavoritesList)));
          verify(
            mockApiService.getFavorites(
              attachImage: 1,
              subId: 'user123',
              page: null,
              limit: null,
              order: 'DESC',
            ),
          ).called(1);
          verifyNoMoreInteractions(mockApiService);
        },
      );

      test(
        'should return Right with empty list when API returns empty list',
        () async {
          // arrange
          when(
            mockApiService.getFavorites(
              attachImage: anyNamed('attachImage'),
              subId: anyNamed('subId'),
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => []);

          // act
          final result = await repository.getFavorites(attachImage: false);

          // assert
          expect(result, equals(const Right([])));
          verify(
            mockApiService.getFavorites(
              attachImage: 0,
              subId: null,
              page: null,
              limit: null,
              order: 'DESC',
            ),
          ).called(1);
        },
      );

      test('should convert attachImage boolean to int correctly', () async {
        // arrange
        when(
          mockApiService.getFavorites(
            attachImage: anyNamed('attachImage'),
            subId: anyNamed('subId'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
            order: anyNamed('order'),
          ),
        ).thenAnswer((_) async => tFavoritesList);

        // act - test with true
        await repository.getFavorites(attachImage: true);
        verify(
          mockApiService.getFavorites(
            attachImage: 1,
            subId: null,
            page: null,
            limit: null,
            order: 'DESC',
          ),
        ).called(1);

        // act - test with false
        await repository.getFavorites(attachImage: false);
        verify(
          mockApiService.getFavorites(
            attachImage: 0,
            subId: null,
            page: null,
            limit: null,
            order: 'DESC',
          ),
        ).called(1);
      });

      test('should pass pagination parameters correctly', () async {
        // arrange
        when(
          mockApiService.getFavorites(
            attachImage: anyNamed('attachImage'),
            subId: anyNamed('subId'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
            order: anyNamed('order'),
          ),
        ).thenAnswer((_) async => tFavoritesList);

        // act
        final result = await repository.getFavorites(
          page: 2,
          limit: 10,
          order: 'ASC',
        );

        // assert
        expect(result.isRight(), true);
        verify(
          mockApiService.getFavorites(
            attachImage: 1,
            subId: null,
            page: 2,
            limit: 10,
            order: 'ASC',
          ),
        ).called(1);
      });

      test(
        'should return Left with ApiErrorModel when DioException occurs',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/favourites'),
            response: Response(
              requestOptions: RequestOptions(path: '/favourites'),
              statusCode: 500,
              data: {'message': 'Server error'},
            ),
            type: DioExceptionType.badResponse,
          );
          when(
            mockApiService.getFavorites(
              attachImage: anyNamed('attachImage'),
              subId: anyNamed('subId'),
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              order: anyNamed('order'),
            ),
          ).thenThrow(dioException);

          // act
          final result = await repository.getFavorites();

          // assert
          expect(result.isLeft(), true);
          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.statusCode, 500);
            expect(error.message, 'Server error');
          }, (_) => fail('Should return Left'));
        },
      );

      test(
        'should return Left with ApiErrorModel for connection error',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/favourites'),
            type: DioExceptionType.connectionError,
          );
          when(
            mockApiService.getFavorites(
              attachImage: anyNamed('attachImage'),
              subId: anyNamed('subId'),
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              order: anyNamed('order'),
            ),
          ).thenThrow(dioException);

          // act
          final result = await repository.getFavorites();

          // assert
          expect(result.isLeft(), true);
          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.message, contains('internet connection'));
          }, (_) => fail('Should return Left'));
        },
      );

      test(
        'should return Left with ApiErrorModel for 401 unauthorized',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/favourites'),
            response: Response(
              requestOptions: RequestOptions(path: '/favourites'),
              statusCode: 401,
              data: {'message': 'Unauthorized'},
            ),
            type: DioExceptionType.badResponse,
          );
          when(
            mockApiService.getFavorites(
              attachImage: anyNamed('attachImage'),
              subId: anyNamed('subId'),
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              order: anyNamed('order'),
            ),
          ).thenThrow(dioException);

          // act
          final result = await repository.getFavorites();

          // assert
          expect(result.isLeft(), true);
          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.statusCode, 401);
            expect(error.icon, Icons.lock);
          }, (_) => fail('Should return Left'));
        },
      );

      test('should return Left with ApiErrorModel for 404 not found', () async {
        // arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/favourites'),
          response: Response(
            requestOptions: RequestOptions(path: '/favourites'),
            statusCode: 404,
            data: {'message': 'Not found'},
          ),
          type: DioExceptionType.badResponse,
        );
        when(
          mockApiService.getFavorites(
            attachImage: anyNamed('attachImage'),
            subId: anyNamed('subId'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
            order: anyNamed('order'),
          ),
        ).thenThrow(dioException);

        // act
        final result = await repository.getFavorites();

        // assert
        expect(result.isLeft(), true);
        result.fold((error) {
          expect(error, isA<ApiErrorModel>());
          expect(error.statusCode, 404);
          expect(error.icon, Icons.search_off);
        }, (_) => fail('Should return Left'));
      });
    });

    group('createFavorite', () {
      final tCreateResponse = CreateFavoriteResponse(id: 1, message: 'SUCCESS');

      test(
        'should return Right with CreateFavoriteResponse when successful',
        () async {
          // arrange
          when(
            mockApiService.createFavorite(any),
          ).thenAnswer((_) async => tCreateResponse);

          // act
          final result = await repository.createFavorite(
            imageId: 'img123',
            subId: 'user123',
          );

          // assert
          expect(result, equals(Right(tCreateResponse)));
          verify(mockApiService.createFavorite(any)).called(1);
          verifyNoMoreInteractions(mockApiService);
        },
      );

      test(
        'should pass correct CreateFavoriteRequest to API service',
        () async {
          // arrange
          when(
            mockApiService.createFavorite(any),
          ).thenAnswer((_) async => tCreateResponse);

          // act
          await repository.createFavorite(imageId: 'img123', subId: 'user123');

          // assert
          final captured =
              verify(mockApiService.createFavorite(captureAny)).captured.single
                  as CreateFavoriteRequest;
          expect(captured.imageId, 'img123');
          expect(captured.subId, 'user123');
        },
      );

      test('should handle null subId', () async {
        // arrange
        when(
          mockApiService.createFavorite(any),
        ).thenAnswer((_) async => tCreateResponse);

        // act
        await repository.createFavorite(imageId: 'img123');

        // assert
        final captured =
            verify(mockApiService.createFavorite(captureAny)).captured.single
                as CreateFavoriteRequest;
        expect(captured.imageId, 'img123');
        expect(captured.subId, null);
      });

      test(
        'should return Left with ApiErrorModel when DioException occurs',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/favourites'),
            response: Response(
              requestOptions: RequestOptions(path: '/favourites'),
              statusCode: 400,
              data: {'message': 'Validation failed'},
            ),
            type: DioExceptionType.badResponse,
          );
          when(mockApiService.createFavorite(any)).thenThrow(dioException);

          // act
          final result = await repository.createFavorite(imageId: 'img123');

          // assert
          expect(result.isLeft(), true);
          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.statusCode, 400);
          }, (_) => fail('Should return Left'));
        },
      );

      test('should return Left with ApiErrorModel for server error', () async {
        // arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/favourites'),
          response: Response(
            requestOptions: RequestOptions(path: '/favourites'),
            statusCode: 500,
            data: {'message': 'Server error'},
          ),
          type: DioExceptionType.badResponse,
        );
        when(mockApiService.createFavorite(any)).thenThrow(dioException);

        // act
        final result = await repository.createFavorite(imageId: 'img123');

        // assert
        expect(result.isLeft(), true);
        result.fold((error) {
          expect(error, isA<ApiErrorModel>());
          expect(error.statusCode, 500);
          expect(error.icon, Icons.error);
        }, (_) => fail('Should return Left'));
      });

      test(
        'should return Left with ApiErrorModel for connection timeout',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/favourites'),
            type: DioExceptionType.connectionTimeout,
          );
          when(mockApiService.createFavorite(any)).thenThrow(dioException);

          // act
          final result = await repository.createFavorite(imageId: 'img123');

          // assert
          expect(result.isLeft(), true);
          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.message, contains('took too long'));
          }, (_) => fail('Should return Left'));
        },
      );
    });

    group('deleteFavorite', () {
      test(
        'should return Right with null when deletion is successful',
        () async {
          // arrange
          when(mockApiService.deleteFavorite(any)).thenAnswer((_) async => {});

          // act
          final result = await repository.deleteFavorite(1);

          // assert
          expect(result, equals(const Right(null)));
          verify(mockApiService.deleteFavorite(1)).called(1);
          verifyNoMoreInteractions(mockApiService);
        },
      );

      test('should pass correct favorite ID to API service', () async {
        // arrange
        when(mockApiService.deleteFavorite(any)).thenAnswer((_) async => {});

        // act
        await repository.deleteFavorite(123);

        // assert
        verify(mockApiService.deleteFavorite(123)).called(1);
      });

      test(
        'should return Left with ApiErrorModel when DioException occurs',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/favourites/1'),
            response: Response(
              requestOptions: RequestOptions(path: '/favourites/1'),
              statusCode: 404,
              data: {'message': 'Favorite not found'},
            ),
            type: DioExceptionType.badResponse,
          );
          when(mockApiService.deleteFavorite(any)).thenThrow(dioException);

          // act
          final result = await repository.deleteFavorite(1);

          // assert
          expect(result.isLeft(), true);
          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.statusCode, 404);
            expect(error.message, 'Favorite not found');
          }, (_) => fail('Should return Left'));
        },
      );

      test(
        'should return Left with ApiErrorModel for 401 unauthorized',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/favourites/1'),
            response: Response(
              requestOptions: RequestOptions(path: '/favourites/1'),
              statusCode: 401,
              data: {'message': 'Unauthorized'},
            ),
            type: DioExceptionType.badResponse,
          );
          when(mockApiService.deleteFavorite(any)).thenThrow(dioException);

          // act
          final result = await repository.deleteFavorite(1);

          // assert
          expect(result.isLeft(), true);
          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.statusCode, 401);
            expect(error.icon, Icons.lock);
          }, (_) => fail('Should return Left'));
        },
      );

      test('should return Left with ApiErrorModel for server error', () async {
        // arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/favourites/1'),
          response: Response(
            requestOptions: RequestOptions(path: '/favourites/1'),
            statusCode: 500,
            data: {'message': 'Server error'},
          ),
          type: DioExceptionType.badResponse,
        );
        when(mockApiService.deleteFavorite(any)).thenThrow(dioException);

        // act
        final result = await repository.deleteFavorite(1);

        // assert
        expect(result.isLeft(), true);
        result.fold((error) {
          expect(error, isA<ApiErrorModel>());
          expect(error.statusCode, 500);
          expect(error.icon, Icons.error);
        }, (_) => fail('Should return Left'));
      });

      test(
        'should return Left with ApiErrorModel for connection error',
        () async {
          // arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/favourites/1'),
            type: DioExceptionType.connectionError,
          );
          when(mockApiService.deleteFavorite(any)).thenThrow(dioException);

          // act
          final result = await repository.deleteFavorite(1);

          // assert
          expect(result.isLeft(), true);
          result.fold((error) {
            expect(error, isA<ApiErrorModel>());
            expect(error.message, contains('internet connection'));
          }, (_) => fail('Should return Left'));
        },
      );
    });
  });
}
