import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  final int id;
  @JsonKey(name: 'image_id')
  final String imageId;
  @JsonKey(name: 'sub_id')
  final String? subId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final FavoriteImageModel? image;

  FavoriteModel({
    required this.id,
    required this.imageId,
    this.subId,
    required this.createdAt,
    this.image,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);
}

@JsonSerializable()
class FavoriteImageModel {
  final String id;
  final String url;

  FavoriteImageModel({required this.id, required this.url});

  factory FavoriteImageModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteImageModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class CreateFavoriteRequest {
  @JsonKey(name: 'image_id')
  final String imageId;
  @JsonKey(name: 'sub_id')
  final String? subId;

  CreateFavoriteRequest({required this.imageId, this.subId});

  factory CreateFavoriteRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFavoriteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFavoriteRequestToJson(this);
}

@JsonSerializable()
class CreateFavoriteResponse {
  final int id;
  final String message;

  CreateFavoriteResponse({required this.id, required this.message});

  factory CreateFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFavoriteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFavoriteResponseToJson(this);
}
