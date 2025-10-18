import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/features/favorites/data/models/favorite_model.dart';

void main() {
  group('FavoriteModel', () {
    test('should create instance from JSON', () {
      // arrange
      final json = {
        'id': 1,
        'image_id': 'img123',
        'sub_id': 'user123',
        'created_at': '2024-01-01T00:00:00Z',
        'image': {'id': 'img123', 'url': 'https://example.com/img.jpg'},
      };

      // act
      final result = FavoriteModel.fromJson(json);

      // assert
      expect(result.id, 1);
      expect(result.imageId, 'img123');
      expect(result.subId, 'user123');
      expect(result.createdAt, '2024-01-01T00:00:00Z');
      expect(result.image, isNotNull);
      expect(result.image!.id, 'img123');
      expect(result.image!.url, 'https://example.com/img.jpg');
    });

    test('should create instance from JSON with null subId', () {
      // arrange
      final json = {
        'id': 1,
        'image_id': 'img123',
        'created_at': '2024-01-01T00:00:00Z',
      };

      // act
      final result = FavoriteModel.fromJson(json);

      // assert
      expect(result.id, 1);
      expect(result.imageId, 'img123');
      expect(result.subId, null);
      expect(result.createdAt, '2024-01-01T00:00:00Z');
      expect(result.image, null);
    });

    test('should create instance from JSON with null image', () {
      // arrange
      final json = {
        'id': 2,
        'image_id': 'img456',
        'sub_id': 'user456',
        'created_at': '2024-01-02T00:00:00Z',
      };

      // act
      final result = FavoriteModel.fromJson(json);

      // assert
      expect(result.id, 2);
      expect(result.imageId, 'img456');
      expect(result.subId, 'user456');
      expect(result.createdAt, '2024-01-02T00:00:00Z');
      expect(result.image, null);
    });

    test('should convert instance to JSON', () {
      // arrange
      final favorite = FavoriteModel(
        id: 1,
        imageId: 'img123',
        subId: 'user123',
        createdAt: '2024-01-01T00:00:00Z',
        image: FavoriteImageModel(
          id: 'img123',
          url: 'https://example.com/img.jpg',
        ),
      );

      // act
      final json = favorite.toJson();

      // assert
      expect(json['id'], 1);
      expect(json['image_id'], 'img123');
      expect(json['sub_id'], 'user123');
      expect(json['created_at'], '2024-01-01T00:00:00Z');
      expect(json['image'], isNotNull);
      expect(json['image']['id'], 'img123');
      expect(json['image']['url'], 'https://example.com/img.jpg');
    });

    test('should convert instance to JSON with null values', () {
      // arrange
      final favorite = FavoriteModel(
        id: 1,
        imageId: 'img123',
        createdAt: '2024-01-01T00:00:00Z',
      );

      // act
      final json = favorite.toJson();

      // assert
      expect(json['id'], 1);
      expect(json['image_id'], 'img123');
      expect(json['sub_id'], null);
      expect(json['created_at'], '2024-01-01T00:00:00Z');
      expect(json['image'], null);
    });

    test('should handle JSON serialization roundtrip', () {
      // arrange
      final original = FavoriteModel(
        id: 1,
        imageId: 'img123',
        subId: 'user123',
        createdAt: '2024-01-01T00:00:00Z',
        image: FavoriteImageModel(
          id: 'img123',
          url: 'https://example.com/img.jpg',
        ),
      );

      // act
      final json = original.toJson();
      final result = FavoriteModel.fromJson(json);

      // assert
      expect(result.id, original.id);
      expect(result.imageId, original.imageId);
      expect(result.subId, original.subId);
      expect(result.createdAt, original.createdAt);
      expect(result.image!.id, original.image!.id);
      expect(result.image!.url, original.image!.url);
    });
  });

  group('FavoriteImageModel', () {
    test('should create instance from JSON', () {
      // arrange
      final json = {'id': 'img123', 'url': 'https://example.com/img.jpg'};

      // act
      final result = FavoriteImageModel.fromJson(json);

      // assert
      expect(result.id, 'img123');
      expect(result.url, 'https://example.com/img.jpg');
    });

    test('should convert instance to JSON', () {
      // arrange
      final image = FavoriteImageModel(
        id: 'img123',
        url: 'https://example.com/img.jpg',
      );

      // act
      final json = image.toJson();

      // assert
      expect(json['id'], 'img123');
      expect(json['url'], 'https://example.com/img.jpg');
    });

    test('should handle JSON serialization roundtrip', () {
      // arrange
      final original = FavoriteImageModel(
        id: 'img123',
        url: 'https://example.com/img.jpg',
      );

      // act
      final json = original.toJson();
      final result = FavoriteImageModel.fromJson(json);

      // assert
      expect(result.id, original.id);
      expect(result.url, original.url);
    });
  });

  group('CreateFavoriteRequest', () {
    test('should create instance with all fields', () {
      // arrange & act
      final request = CreateFavoriteRequest(
        imageId: 'img123',
        subId: 'user123',
      );

      // assert
      expect(request.imageId, 'img123');
      expect(request.subId, 'user123');
    });

    test('should create instance with null subId', () {
      // arrange & act
      final request = CreateFavoriteRequest(imageId: 'img123');

      // assert
      expect(request.imageId, 'img123');
      expect(request.subId, null);
    });

    test('should create instance from JSON', () {
      // arrange
      final json = {'image_id': 'img123', 'sub_id': 'user123'};

      // act
      final result = CreateFavoriteRequest.fromJson(json);

      // assert
      expect(result.imageId, 'img123');
      expect(result.subId, 'user123');
    });

    test('should create instance from JSON with null subId', () {
      // arrange
      final json = {'image_id': 'img123'};

      // act
      final result = CreateFavoriteRequest.fromJson(json);

      // assert
      expect(result.imageId, 'img123');
      expect(result.subId, null);
    });

    test('should convert instance to JSON', () {
      // arrange
      final request = CreateFavoriteRequest(
        imageId: 'img123',
        subId: 'user123',
      );

      // act
      final json = request.toJson();

      // assert
      expect(json['image_id'], 'img123');
      expect(json['sub_id'], 'user123');
    });

    test('should exclude null values from JSON (includeIfNull: false)', () {
      // arrange
      final request = CreateFavoriteRequest(imageId: 'img123');

      // act
      final json = request.toJson();

      // assert
      expect(json['image_id'], 'img123');
      expect(json.containsKey('sub_id'), false);
    });

    test('should handle JSON serialization roundtrip', () {
      // arrange
      final original = CreateFavoriteRequest(
        imageId: 'img123',
        subId: 'user123',
      );

      // act
      final json = original.toJson();
      final result = CreateFavoriteRequest.fromJson(json);

      // assert
      expect(result.imageId, original.imageId);
      expect(result.subId, original.subId);
    });
  });

  group('CreateFavoriteResponse', () {
    test('should create instance from JSON', () {
      // arrange
      final json = {'id': 1, 'message': 'SUCCESS'};

      // act
      final result = CreateFavoriteResponse.fromJson(json);

      // assert
      expect(result.id, 1);
      expect(result.message, 'SUCCESS');
    });

    test('should convert instance to JSON', () {
      // arrange
      final response = CreateFavoriteResponse(id: 1, message: 'SUCCESS');

      // act
      final json = response.toJson();

      // assert
      expect(json['id'], 1);
      expect(json['message'], 'SUCCESS');
    });

    test('should handle JSON serialization roundtrip', () {
      // arrange
      final original = CreateFavoriteResponse(
        id: 123,
        message: 'Favourite added successfully',
      );

      // act
      final json = original.toJson();
      final result = CreateFavoriteResponse.fromJson(json);

      // assert
      expect(result.id, original.id);
      expect(result.message, original.message);
    });

    test('should handle different message values', () {
      // arrange
      final json = {'id': 999, 'message': 'CREATED'};

      // act
      final result = CreateFavoriteResponse.fromJson(json);

      // assert
      expect(result.id, 999);
      expect(result.message, 'CREATED');
    });
  });
}
