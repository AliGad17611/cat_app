import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:cat_app/core/constants/api_constants.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';

part 'home_api_service.g.dart';

@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio) = _HomeApiService;

  @GET(ApiConstants.breedsEndpoint)
  Future<List<BreedModel>> getBreeds(
    @Query('limit') int limit,
    @Query('page') int page,
  );
}
