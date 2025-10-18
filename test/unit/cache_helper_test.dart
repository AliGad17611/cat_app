import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cat_app/core/cache/cache_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CacheHelper', () {
    setUp(() async {
      // Clear all shared preferences before each test
      SharedPreferences.setMockInitialValues({});
      await CacheHelper.init();
    });

    group('set and get String', () {
      test('should save and retrieve string value', () async {
        const key = 'test_string';
        const value = 'test_value';

        await CacheHelper.set(key: key, value: value);
        final result = CacheHelper.getString(key: key);

        expect(result, value);
      });

      test('should return null for non-existent string key', () {
        final result = CacheHelper.getString(key: 'non_existent');
        expect(result, isNull);
      });
    });

    group('set and get int', () {
      test('should save and retrieve int value', () async {
        const key = 'test_int';
        const value = 42;

        await CacheHelper.set(key: key, value: value);
        final result = CacheHelper.getInt(key: key);

        expect(result, value);
      });

      test('should return null for non-existent int key', () {
        final result = CacheHelper.getInt(key: 'non_existent');
        expect(result, isNull);
      });
    });

    group('set and get double', () {
      test('should save and retrieve double value', () async {
        const key = 'test_double';
        const value = 3.14;

        await CacheHelper.set(key: key, value: value);
        final result = CacheHelper.getDouble(key: key);

        expect(result, value);
      });

      test('should return null for non-existent double key', () {
        final result = CacheHelper.getDouble(key: 'non_existent');
        expect(result, isNull);
      });
    });

    group('set and get bool', () {
      test('should save and retrieve bool value', () async {
        const key = 'test_bool';
        const value = true;

        await CacheHelper.set(key: key, value: value);
        final result = CacheHelper.getBool(key: key);

        expect(result, value);
      });

      test('should return null for non-existent bool key', () {
        final result = CacheHelper.getBool(key: 'non_existent');
        expect(result, isNull);
      });
    });

    group('set and get StringList', () {
      test('should save and retrieve string list value', () async {
        const key = 'test_list';
        const value = ['item1', 'item2', 'item3'];

        await CacheHelper.set(key: key, value: value);
        final result = CacheHelper.getStringList(key: key);

        expect(result, value);
      });

      test('should return null for non-existent string list key', () {
        final result = CacheHelper.getStringList(key: 'non_existent');
        expect(result, isNull);
      });
    });

    test('should throw UnsupportedError for unsupported type', () async {
      const key = 'test_unsupported';
      final value = {'map': 'value'};

      expect(
        () => CacheHelper.set(key: key, value: value),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('get method should retrieve string value', () async {
      const key = 'test_get';
      const value = 'test_value';

      await CacheHelper.set(key: key, value: value);
      final result = CacheHelper.get(key: key);

      expect(result, value);
    });

    group('delete', () {
      test('should delete existing key', () async {
        const key = 'test_delete';
        const value = 'test_value';

        await CacheHelper.set(key: key, value: value);
        final deleteResult = await CacheHelper.delete(key: key);
        final getValue = CacheHelper.getString(key: key);

        expect(deleteResult, true);
        expect(getValue, isNull);
      });

      test('should handle deleting non-existent key', () async {
        final result = await CacheHelper.delete(key: 'non_existent');
        // Note: SharedPreferences mock returns true even for non-existent keys
        expect(result, isA<bool>());
      });
    });

    group('clearAllData', () {
      test('should clear all stored data', () async {
        await CacheHelper.set(key: 'key1', value: 'value1');
        await CacheHelper.set(key: 'key2', value: 42);
        await CacheHelper.set(key: 'key3', value: true);

        final clearResult = await CacheHelper.clearAllData();

        expect(clearResult, true);
        expect(CacheHelper.getString(key: 'key1'), isNull);
        expect(CacheHelper.getInt(key: 'key2'), isNull);
        expect(CacheHelper.getBool(key: 'key3'), isNull);
      });
    });
  });
}
