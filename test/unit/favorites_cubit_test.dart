import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/features/favorites/data/repositories/favorites_repository.dart';
import 'package:cat_app/features/favorites/data/models/favorite_model.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';

@GenerateMocks([FavoritesRepository])
import 'favorites_cubit_test.mocks.dart';

void main() {
  late FavoritesCubit cubit;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    cubit = FavoritesCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

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

  final tCreateFavoriteResponse = CreateFavoriteResponse(
    id: 3,
    message: 'SUCCESS',
  );

  group('FavoritesCubit', () {
    test('initial state should be FavoritesState with initial status', () {
      expect(cubit.state, equals(const FavoritesState()));
      expect(cubit.state.status, equals(FavoritesStatus.initial));
      expect(cubit.state.favorites, equals([]));
      expect(cubit.state.favoriteImageIds, equals({}));
    });

    group('loadFavorites', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, success] when favorites are loaded successfully',
        build: () {
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => Right(tFavoritesList));
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(subId: 'user123'),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: tFavoritesList,
            favoriteImageIds: {'img1', 'img2'},
          ),
        ],
        verify: (_) {
          verify(
            mockRepository.getFavorites(
              subId: 'user123',
              attachImage: true,
              order: 'DESC',
            ),
          ).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, success] with empty list when no favorites exist',
        build: () {
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          const FavoritesState(
            status: FavoritesStatus.success,
            favorites: [],
            favoriteImageIds: {},
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, failure] when loading favorites fails',
        build: () {
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer(
            (_) async => Left(
              ApiErrorModel(
                message: 'Failed to load favorites',
                statusCode: 500,
                icon: Icons.error,
              ),
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(subId: 'user123'),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          const FavoritesState(
            status: FavoritesStatus.failure,
            errorMessage: 'Failed to load favorites',
            errorIcon: Icons.error,
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, failure] when network error occurs',
        build: () {
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer(
            (_) async => Left(
              ApiErrorModel(
                message: 'No internet connection',
                statusCode: null,
                icon: Icons.wifi_off,
              ),
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          const FavoritesState(
            status: FavoritesStatus.failure,
            errorMessage: 'No internet connection',
            errorIcon: Icons.wifi_off,
          ),
        ],
      );
    });

    group('addFavorite', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'optimistically adds favorite to state, then reloads on success',
        build: () {
          when(
            mockRepository.createFavorite(
              imageId: anyNamed('imageId'),
              subId: anyNamed('subId'),
            ),
          ).thenAnswer((_) async => Right(tCreateFavoriteResponse));
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => Right(tFavoritesList));
          return cubit;
        },
        act: (cubit) => cubit.addFavorite(imageId: 'img3', subId: 'user123'),
        expect: () => [
          const FavoritesState(favoriteImageIds: {'img3'}),
          const FavoritesState(
            status: FavoritesStatus.loading,
            favoriteImageIds: {'img3'},
          ),
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: tFavoritesList,
            favoriteImageIds: {'img1', 'img2'},
          ),
        ],
        verify: (_) {
          verify(
            mockRepository.createFavorite(imageId: 'img3', subId: 'user123'),
          ).called(1);
          verify(
            mockRepository.getFavorites(
              subId: 'user123',
              attachImage: true,
              order: 'DESC',
            ),
          ).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'reverts optimistic update when adding favorite fails',
        build: () {
          when(
            mockRepository.createFavorite(
              imageId: anyNamed('imageId'),
              subId: anyNamed('subId'),
            ),
          ).thenAnswer(
            (_) async => Left(
              ApiErrorModel(
                message: 'Failed to add favorite',
                statusCode: 500,
                icon: Icons.error,
              ),
            ),
          );
          return cubit;
        },
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        ),
        act: (cubit) => cubit.addFavorite(imageId: 'img3', subId: 'user123'),
        expect: () => [
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: tFavoritesList,
            favoriteImageIds: {'img1', 'img2', 'img3'},
          ),
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: tFavoritesList,
            favoriteImageIds: {'img1', 'img2'},
            errorMessage: 'Failed to add favorite',
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'adds favorite to existing list',
        build: () {
          when(
            mockRepository.createFavorite(
              imageId: anyNamed('imageId'),
              subId: anyNamed('subId'),
            ),
          ).thenAnswer((_) async => Right(tCreateFavoriteResponse));
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => Right(tFavoritesList));
          return cubit;
        },
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: [tFavoritesList[0]],
          favoriteImageIds: {'img1'},
        ),
        act: (cubit) => cubit.addFavorite(imageId: 'img2', subId: 'user123'),
        verify: (_) {
          verify(
            mockRepository.createFavorite(imageId: 'img2', subId: 'user123'),
          ).called(1);
        },
      );
    });

    group('removeFavorite', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'optimistically removes favorite from state on success',
        build: () {
          when(
            mockRepository.deleteFavorite(any),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        ),
        act: (cubit) => cubit.removeFavorite(imageId: 'img1', subId: 'user123'),
        expect: () => [
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: [tFavoritesList[1]],
            favoriteImageIds: {'img2'},
          ),
        ],
        verify: (_) {
          verify(mockRepository.deleteFavorite(1)).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'reloads favorites when removal fails',
        build: () {
          when(mockRepository.deleteFavorite(any)).thenAnswer(
            (_) async => Left(
              ApiErrorModel(
                message: 'Failed to remove favorite',
                statusCode: 500,
                icon: Icons.error,
              ),
            ),
          );
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => Right(tFavoritesList));
          return cubit;
        },
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        ),
        act: (cubit) => cubit.removeFavorite(imageId: 'img1', subId: 'user123'),
        verify: (_) {
          verify(mockRepository.deleteFavorite(1)).called(1);
          verify(
            mockRepository.getFavorites(
              subId: 'user123',
              attachImage: true,
              order: 'DESC',
            ),
          ).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'does nothing when favorite ID is not found',
        build: () => cubit,
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        ),
        act: (cubit) =>
            cubit.removeFavorite(imageId: 'non_existent', subId: 'user123'),
        expect: () => [],
        verify: (_) {
          verifyNever(mockRepository.deleteFavorite(any));
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'removes favorite from list with multiple items',
        build: () {
          when(
            mockRepository.deleteFavorite(any),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        ),
        act: (cubit) => cubit.removeFavorite(imageId: 'img2', subId: 'user123'),
        expect: () => [
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: [tFavoritesList[0]],
            favoriteImageIds: {'img1'},
          ),
        ],
      );
    });

    group('toggleFavorite', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'calls addFavorite when image is not a favorite',
        build: () {
          when(
            mockRepository.createFavorite(
              imageId: anyNamed('imageId'),
              subId: anyNamed('subId'),
            ),
          ).thenAnswer((_) async => Right(tCreateFavoriteResponse));
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => Right(tFavoritesList));
          return cubit;
        },
        seed: () => const FavoritesState(
          status: FavoritesStatus.success,
          favorites: [],
          favoriteImageIds: {},
        ),
        act: (cubit) => cubit.toggleFavorite(imageId: 'img3', subId: 'user123'),
        verify: (_) {
          verify(
            mockRepository.createFavorite(imageId: 'img3', subId: 'user123'),
          ).called(1);
          verifyNever(mockRepository.deleteFavorite(any));
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'calls removeFavorite when image is already a favorite',
        build: () {
          when(
            mockRepository.deleteFavorite(any),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        ),
        act: (cubit) => cubit.toggleFavorite(imageId: 'img1', subId: 'user123'),
        verify: (_) {
          verify(mockRepository.deleteFavorite(1)).called(1);
          verifyNever(
            mockRepository.createFavorite(
              imageId: anyNamed('imageId'),
              subId: anyNamed('subId'),
            ),
          );
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'toggles from not favorite to favorite',
        build: () {
          when(
            mockRepository.createFavorite(
              imageId: anyNamed('imageId'),
              subId: anyNamed('subId'),
            ),
          ).thenAnswer((_) async => Right(tCreateFavoriteResponse));
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer((_) async => Right(tFavoritesList));
          return cubit;
        },
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: [tFavoritesList[0]],
          favoriteImageIds: {'img1'},
        ),
        act: (cubit) => cubit.toggleFavorite(imageId: 'img2', subId: 'user123'),
        verify: (_) {
          verify(
            mockRepository.createFavorite(imageId: 'img2', subId: 'user123'),
          ).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'toggles from favorite to not favorite',
        build: () {
          when(
            mockRepository.deleteFavorite(any),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        ),
        act: (cubit) => cubit.toggleFavorite(imageId: 'img2', subId: 'user123'),
        expect: () => [
          FavoritesState(
            status: FavoritesStatus.success,
            favorites: [tFavoritesList[0]],
            favoriteImageIds: {'img1'},
          ),
        ],
      );
    });

    group('error scenarios', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'handles 401 unauthorized error correctly',
        build: () {
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer(
            (_) async => Left(
              ApiErrorModel(
                message: 'Unauthorized',
                statusCode: 401,
                icon: Icons.lock,
              ),
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          const FavoritesState(
            status: FavoritesStatus.failure,
            errorMessage: 'Unauthorized',
            errorIcon: Icons.lock,
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'handles 404 not found error correctly',
        build: () {
          when(
            mockRepository.getFavorites(
              subId: anyNamed('subId'),
              attachImage: anyNamed('attachImage'),
              order: anyNamed('order'),
            ),
          ).thenAnswer(
            (_) async => Left(
              ApiErrorModel(
                message: 'Not found',
                statusCode: 404,
                icon: Icons.search_off,
              ),
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          const FavoritesState(
            status: FavoritesStatus.failure,
            errorMessage: 'Not found',
            errorIcon: Icons.search_off,
          ),
        ],
      );
    });
  });
}
