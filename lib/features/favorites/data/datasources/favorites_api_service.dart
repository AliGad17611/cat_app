import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:cat_app/core/constants/api_constants.dart';
import 'package:cat_app/features/favorites/data/models/favorite_model.dart';

part 'favorites_api_service.g.dart';

@RestApi()
abstract class FavoritesApiService {
  factory FavoritesApiService(Dio dio) = _FavoritesApiService;

  @POST(ApiConstants.favoritesEndpoint)
  Future<CreateFavoriteResponse> createFavorite(
    @Body() CreateFavoriteRequest request,
  );

  @GET(ApiConstants.favoritesEndpoint)
  Future<List<FavoriteModel>> getFavorites({
    @Query('attach_image') int? attachImage,
    @Query('image_id') String? imageId,
    @Query('sub_id') String? subId,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('order') String? order,
  });

  @DELETE('${ApiConstants.favoritesEndpoint}/{favouriteId}')
  Future<void> deleteFavorite(@Path('favouriteId') int favouriteId);
}
