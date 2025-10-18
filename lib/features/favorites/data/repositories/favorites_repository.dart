import 'package:cat_app/core/errors/api_error_handler.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/features/favorites/data/datasources/favorites_api_service.dart';
import 'package:cat_app/features/favorites/data/models/favorite_model.dart';
import 'package:dartz/dartz.dart';

class FavoritesRepository {
  final FavoritesApiService _apiService;

  FavoritesRepository(this._apiService);

  Future<Either<ApiErrorModel, CreateFavoriteResponse>> createFavorite({
    required String imageId,
    String? subId,
  }) async {
    try {
      final request = CreateFavoriteRequest(imageId: imageId, subId: subId);
      final response = await _apiService.createFavorite(request);
      return Right(response);
    } catch (e) {
      final apiError = ApiErrorHandler.handle(e);
      return Left(apiError);
    }
  }

  Future<Either<ApiErrorModel, List<FavoriteModel>>> getFavorites({
    String? subId,
    int? page,
    int? limit,
    String order = 'DESC',
    bool attachImage = true,
  }) async {
    try {
      final favorites = await _apiService.getFavorites(
        attachImage: attachImage ? 1 : 0,
        subId: subId,
        page: page,
        limit: limit,
        order: order,
      );
      return Right(favorites);
    } catch (e) {
      final apiError = ApiErrorHandler.handle(e);
      return Left(apiError);
    }
  }

  Future<Either<ApiErrorModel, void>> deleteFavorite(int favouriteId) async {
    try {
      await _apiService.deleteFavorite(favouriteId);
      return const Right(null);
    } catch (e) {
      final apiError = ApiErrorHandler.handle(e);
      return Left(apiError);
    }
  }
}
