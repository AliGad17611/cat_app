import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_app/features/favorites/data/repositories/favorites_repository.dart';
import 'package:cat_app/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesState());

  Future<void> loadFavorites({String? subId}) async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    final result = await _repository.getFavorites(
      subId: subId,
      attachImage: true,
      order: 'DESC',
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FavoritesStatus.failure,
            errorMessage: failure.message,
            errorIcon: failure.icon,
          ),
        );
      },
      (favorites) {
        final imageIds = favorites.map((fav) => fav.imageId).toSet();
        emit(
          state.copyWith(
            status: FavoritesStatus.success,
            favorites: favorites,
            favoriteImageIds: imageIds,
          ),
        );
      },
    );
  }

  Future<void> addFavorite({required String imageId, String? subId}) async {
    // Optimistically update UI
    final updatedImageIds = {...state.favoriteImageIds, imageId};
    emit(state.copyWith(favoriteImageIds: updatedImageIds));

    final result = await _repository.createFavorite(
      imageId: imageId,
      subId: subId,
    );

    result.fold(
      (failure) {
        // Revert on failure
        final revertedImageIds = {...state.favoriteImageIds};
        revertedImageIds.remove(imageId);
        emit(
          state.copyWith(
            favoriteImageIds: revertedImageIds,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        // Reload to get the complete favorite object with ID
        loadFavorites(subId: subId);
      },
    );
  }

  Future<void> removeFavorite({required String imageId, String? subId}) async {
    final favoriteId = state.getFavoriteId(imageId);
    if (favoriteId == null) return;

    // Optimistically update UI
    final updatedImageIds = {...state.favoriteImageIds};
    updatedImageIds.remove(imageId);
    final updatedFavorites = state.favorites
        .where((fav) => fav.imageId != imageId)
        .toList();

    emit(
      state.copyWith(
        favorites: updatedFavorites,
        favoriteImageIds: updatedImageIds,
      ),
    );

    final result = await _repository.deleteFavorite(favoriteId);

    result.fold(
      (failure) {
        // Revert on failure - reload from server
        loadFavorites(subId: subId);
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }

  Future<void> toggleFavorite({required String imageId, String? subId}) async {
    if (state.isFavorite(imageId)) {
      await removeFavorite(imageId: imageId, subId: subId);
    } else {
      await addFavorite(imageId: imageId, subId: subId);
    }
  }
}
