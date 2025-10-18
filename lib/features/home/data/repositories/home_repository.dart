import 'package:cat_app/core/constants/pagination_constants.dart';
import 'package:cat_app/core/errors/api_error_handler.dart';
import 'package:cat_app/core/errors/api_error_model.dart';
import 'package:cat_app/features/home/data/datasources/home_api_service.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:dartz/dartz.dart';

class HomeRepository {
  final HomeApiService _apiService;

  HomeRepository(this._apiService);

  Future<Either<ApiErrorModel, List<BreedModel>>> getBreeds({
    int page = 0,
    int limit = PaginationConstants.pageSize,
  }) async {
    try {
      final breeds = await _apiService.getBreeds(limit, page);
      return Right(breeds);
    } catch (e) {
      final apiError = ApiErrorHandler.handle(e);
      return Left(apiError);
    }
  }
}
