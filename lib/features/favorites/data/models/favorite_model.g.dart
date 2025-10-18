// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      id: (json['id'] as num).toInt(),
      imageId: json['image_id'] as String,
      subId: json['sub_id'] as String?,
      createdAt: json['created_at'] as String,
      image: json['image'] == null
          ? null
          : FavoriteImageModel.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_id': instance.imageId,
      'sub_id': instance.subId,
      'created_at': instance.createdAt,
      'image': instance.image?.toJson(),
    };

FavoriteImageModel _$FavoriteImageModelFromJson(Map<String, dynamic> json) =>
    FavoriteImageModel(id: json['id'] as String, url: json['url'] as String);

Map<String, dynamic> _$FavoriteImageModelToJson(FavoriteImageModel instance) =>
    <String, dynamic>{'id': instance.id, 'url': instance.url};

CreateFavoriteRequest _$CreateFavoriteRequestFromJson(
  Map<String, dynamic> json,
) => CreateFavoriteRequest(
  imageId: json['image_id'] as String,
  subId: json['sub_id'] as String?,
);

Map<String, dynamic> _$CreateFavoriteRequestToJson(
  CreateFavoriteRequest instance,
) => <String, dynamic>{
  'image_id': instance.imageId,
  if (instance.subId case final value?) 'sub_id': value,
};

CreateFavoriteResponse _$CreateFavoriteResponseFromJson(
  Map<String, dynamic> json,
) => CreateFavoriteResponse(
  id: (json['id'] as num).toInt(),
  message: json['message'] as String,
);

Map<String, dynamic> _$CreateFavoriteResponseToJson(
  CreateFavoriteResponse instance,
) => <String, dynamic>{'id': instance.id, 'message': instance.message};
