import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/features/favorites/data/models/favorite_model.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';

void main() {
  group('FavoritesState', () {
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

    test('should have initial status by default', () {
      // act
      const state = FavoritesState();

      // assert
      expect(state.status, FavoritesStatus.initial);
      expect(state.favorites, equals([]));
      expect(state.favoriteImageIds, equals({}));
      expect(state.errorMessage, null);
      expect(state.errorIcon, null);
    });

    test('should create state with custom status', () {
      // act
      const state = FavoritesState(status: FavoritesStatus.loading);

      // assert
      expect(state.status, FavoritesStatus.loading);
    });

    test('should create state with favorites list', () {
      // act
      final state = FavoritesState(
        status: FavoritesStatus.success,
        favorites: tFavoritesList,
      );

      // assert
      expect(state.status, FavoritesStatus.success);
      expect(state.favorites, tFavoritesList);
      expect(state.favorites.length, 2);
    });

    test('should create state with favoriteImageIds set', () {
      // act
      const state = FavoritesState(
        status: FavoritesStatus.success,
        favoriteImageIds: {'img1', 'img2', 'img3'},
      );

      // assert
      expect(state.favoriteImageIds, {'img1', 'img2', 'img3'});
      expect(state.favoriteImageIds.length, 3);
    });

    test('should create state with error message and icon', () {
      // act
      const state = FavoritesState(
        status: FavoritesStatus.failure,
        errorMessage: 'Failed to load favorites',
        errorIcon: Icons.error,
      );

      // assert
      expect(state.status, FavoritesStatus.failure);
      expect(state.errorMessage, 'Failed to load favorites');
      expect(state.errorIcon, Icons.error);
    });

    group('copyWith', () {
      test('should copy state with new status', () {
        // arrange
        const original = FavoritesState(status: FavoritesStatus.initial);

        // act
        final copied = original.copyWith(status: FavoritesStatus.loading);

        // assert
        expect(copied.status, FavoritesStatus.loading);
        expect(copied.favorites, original.favorites);
        expect(copied.favoriteImageIds, original.favoriteImageIds);
      });

      test('should copy state with new favorites list', () {
        // arrange
        const original = FavoritesState();

        // act
        final copied = original.copyWith(favorites: tFavoritesList);

        // assert
        expect(copied.favorites, tFavoritesList);
        expect(copied.status, original.status);
      });

      test('should copy state with new favoriteImageIds', () {
        // arrange
        const original = FavoritesState();

        // act
        final copied = original.copyWith(favoriteImageIds: {'img1', 'img2'});

        // assert
        expect(copied.favoriteImageIds, {'img1', 'img2'});
        expect(copied.status, original.status);
      });

      test('should copy state with new error message', () {
        // arrange
        const original = FavoritesState();

        // act
        final copied = original.copyWith(errorMessage: 'Network error');

        // assert
        expect(copied.errorMessage, 'Network error');
        expect(copied.status, original.status);
      });

      test('should copy state with new error icon', () {
        // arrange
        const original = FavoritesState();

        // act
        final copied = original.copyWith(errorIcon: Icons.wifi_off);

        // assert
        expect(copied.errorIcon, Icons.wifi_off);
        expect(copied.status, original.status);
      });

      test('should copy state with multiple new values', () {
        // arrange
        const original = FavoritesState();

        // act
        final copied = original.copyWith(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        );

        // assert
        expect(copied.status, FavoritesStatus.success);
        expect(copied.favorites, tFavoritesList);
        expect(copied.favoriteImageIds, {'img1', 'img2'});
      });

      test(
        'should preserve original values when not specified in copyWith',
        () {
          // arrange
          final original = FavoritesState(
            status: FavoritesStatus.success,
            favorites: tFavoritesList,
            favoriteImageIds: {'img1', 'img2'},
            errorMessage: 'Some error',
            errorIcon: Icons.error,
          );

          // act
          final copied = original.copyWith(status: FavoritesStatus.loading);

          // assert
          expect(copied.status, FavoritesStatus.loading);
          expect(copied.favorites, original.favorites);
          expect(copied.favoriteImageIds, original.favoriteImageIds);
          expect(copied.errorMessage, original.errorMessage);
          expect(copied.errorIcon, original.errorIcon);
        },
      );
    });

    group('isFavorite', () {
      test('should return true when imageId is in favoriteImageIds', () {
        // arrange
        const state = FavoritesState(
          favoriteImageIds: {'img1', 'img2', 'img3'},
        );

        // act & assert
        expect(state.isFavorite('img1'), true);
        expect(state.isFavorite('img2'), true);
        expect(state.isFavorite('img3'), true);
      });

      test('should return false when imageId is not in favoriteImageIds', () {
        // arrange
        const state = FavoritesState(favoriteImageIds: {'img1', 'img2'});

        // act & assert
        expect(state.isFavorite('img3'), false);
        expect(state.isFavorite('img4'), false);
      });

      test('should return false when favoriteImageIds is empty', () {
        // arrange
        const state = FavoritesState();

        // act & assert
        expect(state.isFavorite('img1'), false);
      });

      test('should be case-sensitive', () {
        // arrange
        const state = FavoritesState(favoriteImageIds: {'img1'});

        // act & assert
        expect(state.isFavorite('img1'), true);
        expect(state.isFavorite('IMG1'), false);
        expect(state.isFavorite('Img1'), false);
      });
    });

    group('getFavoriteId', () {
      test('should return favorite id when imageId exists', () {
        // arrange
        final state = FavoritesState(favorites: tFavoritesList);

        // act & assert
        expect(state.getFavoriteId('img1'), 1);
        expect(state.getFavoriteId('img2'), 2);
      });

      test('should return null when imageId does not exist', () {
        // arrange
        final state = FavoritesState(favorites: tFavoritesList);

        // act
        final result = state.getFavoriteId('img999');

        // assert
        expect(result, null);
      });

      test('should return null when favorites list is empty', () {
        // arrange
        const state = FavoritesState();

        // act
        final result = state.getFavoriteId('img1');

        // assert
        expect(result, null);
      });

      test('should return first matching favorite id', () {
        // arrange
        final duplicates = [
          FavoriteModel(
            id: 1,
            imageId: 'img1',
            createdAt: '2024-01-01T00:00:00Z',
          ),
          FavoriteModel(
            id: 2,
            imageId: 'img1',
            createdAt: '2024-01-02T00:00:00Z',
          ),
        ];
        final state = FavoritesState(favorites: duplicates);

        // act
        final result = state.getFavoriteId('img1');

        // assert
        expect(result, 1);
      });

      test('should be case-sensitive for imageId', () {
        // arrange
        final state = FavoritesState(favorites: tFavoritesList);

        // act & assert
        expect(state.getFavoriteId('img1'), 1);
        expect(state.getFavoriteId('IMG1'), null);
        expect(state.getFavoriteId('Img1'), null);
      });
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        // arrange
        final state1 = FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        );
        final state2 = FavoritesState(
          status: FavoritesStatus.success,
          favorites: tFavoritesList,
          favoriteImageIds: {'img1', 'img2'},
        );

        // act & assert
        expect(state1, equals(state2));
      });

      test('should not be equal when status is different', () {
        // arrange
        const state1 = FavoritesState(status: FavoritesStatus.initial);
        const state2 = FavoritesState(status: FavoritesStatus.loading);

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when favorites list is different', () {
        // arrange
        final state1 = FavoritesState(favorites: tFavoritesList);
        const state2 = FavoritesState(favorites: []);

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when favoriteImageIds is different', () {
        // arrange
        const state1 = FavoritesState(favoriteImageIds: {'img1'});
        const state2 = FavoritesState(favoriteImageIds: {'img2'});

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorMessage is different', () {
        // arrange
        const state1 = FavoritesState(errorMessage: 'Error 1');
        const state2 = FavoritesState(errorMessage: 'Error 2');

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorIcon is different', () {
        // arrange
        const state1 = FavoritesState(errorIcon: Icons.error);
        const state2 = FavoritesState(errorIcon: Icons.wifi_off);

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should have consistent hashCode for equal states', () {
        // arrange
        const state1 = FavoritesState(
          status: FavoritesStatus.success,
          favoriteImageIds: {'img1'},
        );
        const state2 = FavoritesState(
          status: FavoritesStatus.success,
          favoriteImageIds: {'img1'},
        );

        // act & assert
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('FavoritesStatus', () {
      test('should have all expected statuses', () {
        // assert
        expect(FavoritesStatus.initial, isNotNull);
        expect(FavoritesStatus.loading, isNotNull);
        expect(FavoritesStatus.success, isNotNull);
        expect(FavoritesStatus.failure, isNotNull);
      });

      test('should have exactly 4 statuses', () {
        // assert
        expect(FavoritesStatus.values.length, 4);
      });
    });
  });
}
