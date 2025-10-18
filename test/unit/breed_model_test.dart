import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/features/home/data/models/breed_model.dart';
import 'package:cat_app/features/home/data/models/weight_model.dart';

void main() {
  group('BreedModel', () {
    test('should create instance from JSON with all fields', () {
      // arrange
      final json = {
        'weight': {'imperial': '7 - 10', 'metric': '3 - 5'},
        'id': 'abys',
        'name': 'Abyssinian',
        'cfa_url': 'https://cfa.org/abyssinian',
        'vetstreet_url': 'https://vetstreet.com/abyssinian',
        'vcahospitals_url': 'https://vca.com/abyssinian',
        'temperament': 'Active, Energetic, Independent',
        'origin': 'Egypt',
        'country_codes': 'EG',
        'country_code': 'EG',
        'description': 'The Abyssinian is easy to care for.',
        'life_span': '14 - 15',
        'indoor': 1,
        'lap': 0,
        'alt_names': 'Abys',
        'adaptability': 5,
        'affection_level': 5,
        'child_friendly': 4,
        'dog_friendly': 4,
        'energy_level': 5,
        'grooming': 1,
        'health_issues': 2,
        'intelligence': 5,
        'shedding_level': 2,
        'social_needs': 5,
        'stranger_friendly': 3,
        'vocalisation': 3,
        'experimental': 0,
        'hairless': 0,
        'natural': 1,
        'rare': 0,
        'rex': 0,
        'suppressed_tail': 0,
        'short_legs': 0,
        'wikipedia_url': 'https://en.wikipedia.org/wiki/Abyssinian',
        'hypoallergenic': 0,
        'reference_image_id': '0XYvRd7oD',
      };

      // act
      final result = BreedModel.fromJson(json);

      // assert
      expect(result.id, 'abys');
      expect(result.name, 'Abyssinian');
      expect(result.weight.imperial, '7 - 10');
      expect(result.weight.metric, '3 - 5');
      expect(result.cfaUrl, 'https://cfa.org/abyssinian');
      expect(result.vetstreetUrl, 'https://vetstreet.com/abyssinian');
      expect(result.vcahospitalsUrl, 'https://vca.com/abyssinian');
      expect(result.temperament, 'Active, Energetic, Independent');
      expect(result.origin, 'Egypt');
      expect(result.countryCodes, 'EG');
      expect(result.countryCode, 'EG');
      expect(result.description, 'The Abyssinian is easy to care for.');
      expect(result.lifeSpan, '14 - 15');
      expect(result.indoor, 1);
      expect(result.lap, 0);
      expect(result.altNames, 'Abys');
      expect(result.adaptability, 5);
      expect(result.affectionLevel, 5);
      expect(result.childFriendly, 4);
      expect(result.dogFriendly, 4);
      expect(result.energyLevel, 5);
      expect(result.grooming, 1);
      expect(result.healthIssues, 2);
      expect(result.intelligence, 5);
      expect(result.sheddingLevel, 2);
      expect(result.socialNeeds, 5);
      expect(result.strangerFriendly, 3);
      expect(result.vocalisation, 3);
      expect(result.experimental, 0);
      expect(result.hairless, 0);
      expect(result.natural, 1);
      expect(result.rare, 0);
      expect(result.rex, 0);
      expect(result.suppressedTail, 0);
      expect(result.shortLegs, 0);
      expect(result.wikipediaUrl, 'https://en.wikipedia.org/wiki/Abyssinian');
      expect(result.hypoallergenic, 0);
      expect(result.referenceImageId, '0XYvRd7oD');
    });

    test('should create instance from JSON with minimal required fields', () {
      // arrange
      final json = {
        'weight': {'imperial': '7 - 10', 'metric': '3 - 5'},
        'id': 'abys',
        'name': 'Abyssinian',
        'description': 'The Abyssinian is easy to care for.',
      };

      // act
      final result = BreedModel.fromJson(json);

      // assert
      expect(result.id, 'abys');
      expect(result.name, 'Abyssinian');
      expect(result.description, 'The Abyssinian is easy to care for.');
      expect(result.weight.imperial, '7 - 10');
      expect(result.weight.metric, '3 - 5');
      expect(result.cfaUrl, null);
      expect(result.temperament, null);
      expect(result.origin, null);
      expect(result.lifeSpan, null);
      expect(result.referenceImageId, null);
    });

    test('should convert instance to JSON', () {
      // arrange
      final breed = BreedModel(
        weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
        id: 'abys',
        name: 'Abyssinian',
        description: 'Test description',
        temperament: 'Active, Energetic',
        origin: 'Egypt',
        lifeSpan: '14 - 15',
        referenceImageId: '0XYvRd7oD',
      );

      // act
      final json = breed.toJson();

      // assert
      expect(json['id'], 'abys');
      expect(json['name'], 'Abyssinian');
      expect(json['description'], 'Test description');
      expect(json['temperament'], 'Active, Energetic');
      expect(json['origin'], 'Egypt');
      expect(json['life_span'], '14 - 15');
      expect(json['reference_image_id'], '0XYvRd7oD');
      expect(json['weight']['imperial'], '7 - 10');
      expect(json['weight']['metric'], '3 - 5');
    });

    test('should handle JSON serialization roundtrip', () {
      // arrange
      final original = BreedModel(
        weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
        id: 'abys',
        name: 'Abyssinian',
        description: 'Test description',
        temperament: 'Active, Energetic',
        origin: 'Egypt',
        lifeSpan: '14 - 15',
        cfaUrl: 'https://cfa.org/abyssinian',
        vetstreetUrl: 'https://vetstreet.com/abyssinian',
        adaptability: 5,
        affectionLevel: 5,
        childFriendly: 4,
        dogFriendly: 4,
        energyLevel: 5,
        referenceImageId: '0XYvRd7oD',
      );

      // act
      final json = original.toJson();
      final result = BreedModel.fromJson(json);

      // assert
      expect(result.id, original.id);
      expect(result.name, original.name);
      expect(result.description, original.description);
      expect(result.temperament, original.temperament);
      expect(result.origin, original.origin);
      expect(result.lifeSpan, original.lifeSpan);
      expect(result.weight.imperial, original.weight.imperial);
      expect(result.weight.metric, original.weight.metric);
      expect(result.cfaUrl, original.cfaUrl);
      expect(result.vetstreetUrl, original.vetstreetUrl);
      expect(result.adaptability, original.adaptability);
      expect(result.affectionLevel, original.affectionLevel);
      expect(result.childFriendly, original.childFriendly);
      expect(result.dogFriendly, original.dogFriendly);
      expect(result.energyLevel, original.energyLevel);
      expect(result.referenceImageId, original.referenceImageId);
    });

    test(
      'imageUrl getter should return correct URL when referenceImageId exists',
      () {
        // arrange
        final breed = BreedModel(
          weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
          id: 'abys',
          name: 'Abyssinian',
          description: 'Test description',
          referenceImageId: '0XYvRd7oD',
        );

        // act
        final imageUrl = breed.imageUrl;

        // assert
        expect(imageUrl, 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg');
      },
    );

    test(
      'imageUrl getter should return null when referenceImageId is null',
      () {
        // arrange
        final breed = BreedModel(
          weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
          id: 'abys',
          name: 'Abyssinian',
          description: 'Test description',
          referenceImageId: null,
        );

        // act
        final imageUrl = breed.imageUrl;

        // assert
        expect(imageUrl, null);
      },
    );

    test(
      'imageUrl getter should return null when referenceImageId is empty',
      () {
        // arrange
        final breed = BreedModel(
          weight: WeightModel(imperial: '7 - 10', metric: '3 - 5'),
          id: 'abys',
          name: 'Abyssinian',
          description: 'Test description',
          referenceImageId: '',
        );

        // act
        final imageUrl = breed.imageUrl;

        // assert
        expect(imageUrl, null);
      },
    );

    test('should correctly parse snake_case JSON keys', () {
      // arrange
      final json = {
        'weight': {'imperial': '7 - 10', 'metric': '3 - 5'},
        'id': 'abys',
        'name': 'Abyssinian',
        'description': 'Test',
        'cfa_url': 'https://cfa.org',
        'life_span': '14 - 15',
        'affection_level': 5,
        'child_friendly': 4,
        'dog_friendly': 4,
        'energy_level': 5,
        'health_issues': 2,
        'shedding_level': 2,
        'social_needs': 5,
        'stranger_friendly': 3,
        'suppressed_tail': 0,
        'short_legs': 0,
        'wikipedia_url': 'https://wikipedia.org',
        'reference_image_id': '0XYvRd7oD',
      };

      // act
      final result = BreedModel.fromJson(json);

      // assert
      expect(result.cfaUrl, 'https://cfa.org');
      expect(result.lifeSpan, '14 - 15');
      expect(result.affectionLevel, 5);
      expect(result.childFriendly, 4);
      expect(result.dogFriendly, 4);
      expect(result.energyLevel, 5);
      expect(result.healthIssues, 2);
      expect(result.sheddingLevel, 2);
      expect(result.socialNeeds, 5);
      expect(result.strangerFriendly, 3);
      expect(result.suppressedTail, 0);
      expect(result.shortLegs, 0);
      expect(result.wikipediaUrl, 'https://wikipedia.org');
      expect(result.referenceImageId, '0XYvRd7oD');
    });

    test('should handle all nullable integer fields as null', () {
      // arrange
      final json = {
        'weight': {'imperial': '7 - 10', 'metric': '3 - 5'},
        'id': 'abys',
        'name': 'Abyssinian',
        'description': 'Test',
      };

      // act
      final result = BreedModel.fromJson(json);

      // assert
      expect(result.indoor, null);
      expect(result.lap, null);
      expect(result.adaptability, null);
      expect(result.affectionLevel, null);
      expect(result.childFriendly, null);
      expect(result.dogFriendly, null);
      expect(result.energyLevel, null);
      expect(result.grooming, null);
      expect(result.healthIssues, null);
      expect(result.intelligence, null);
      expect(result.sheddingLevel, null);
      expect(result.socialNeeds, null);
      expect(result.strangerFriendly, null);
      expect(result.vocalisation, null);
      expect(result.experimental, null);
      expect(result.hairless, null);
      expect(result.natural, null);
      expect(result.rare, null);
      expect(result.rex, null);
      expect(result.suppressedTail, null);
      expect(result.shortLegs, null);
      expect(result.hypoallergenic, null);
    });

    test('should handle multiple breeds from API response', () {
      // arrange
      final jsonList = [
        {
          'weight': {'imperial': '7 - 10', 'metric': '3 - 5'},
          'id': 'abys',
          'name': 'Abyssinian',
          'description': 'Test 1',
        },
        {
          'weight': {'imperial': '5 - 9', 'metric': '2 - 4'},
          'id': 'aege',
          'name': 'Aegean',
          'description': 'Test 2',
        },
      ];

      // act
      final results = jsonList
          .map((json) => BreedModel.fromJson(json))
          .toList();

      // assert
      expect(results.length, 2);
      expect(results[0].id, 'abys');
      expect(results[0].name, 'Abyssinian');
      expect(results[1].id, 'aege');
      expect(results[1].name, 'Aegean');
    });
  });

  group('WeightModel', () {
    test('should create instance from JSON', () {
      // arrange
      final json = {'imperial': '7 - 10', 'metric': '3 - 5'};

      // act
      final result = WeightModel.fromJson(json);

      // assert
      expect(result.imperial, '7 - 10');
      expect(result.metric, '3 - 5');
    });

    test('should convert instance to JSON', () {
      // arrange
      final weight = WeightModel(imperial: '7 - 10', metric: '3 - 5');

      // act
      final json = weight.toJson();

      // assert
      expect(json['imperial'], '7 - 10');
      expect(json['metric'], '3 - 5');
    });

    test('should handle JSON serialization roundtrip', () {
      // arrange
      final original = WeightModel(imperial: '7 - 10', metric: '3 - 5');

      // act
      final json = original.toJson();
      final result = WeightModel.fromJson(json);

      // assert
      expect(result.imperial, original.imperial);
      expect(result.metric, original.metric);
    });

    test('should handle different weight ranges', () {
      // arrange
      final testCases = [
        {'imperial': '5 - 9', 'metric': '2 - 4'},
        {'imperial': '12 - 20', 'metric': '5 - 9'},
        {'imperial': '3 - 6', 'metric': '1 - 3'},
      ];

      for (final json in testCases) {
        // act
        final result = WeightModel.fromJson(json);

        // assert
        expect(result.imperial, json['imperial']);
        expect(result.metric, json['metric']);
      }
    });

    test('should handle empty string values', () {
      // arrange
      final json = {'imperial': '', 'metric': ''};

      // act
      final result = WeightModel.fromJson(json);

      // assert
      expect(result.imperial, '');
      expect(result.metric, '');
    });

    test('should handle weight values with spaces', () {
      // arrange
      final json = {'imperial': '  7 - 10  ', 'metric': '  3 - 5  '};

      // act
      final result = WeightModel.fromJson(json);

      // assert
      expect(result.imperial, '  7 - 10  ');
      expect(result.metric, '  3 - 5  ');
    });
  });
}
