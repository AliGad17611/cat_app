# Unit Tests for Cat App

## Overview
This directory contains comprehensive unit tests for the Cat App, covering repositories, cubits, models, error handling, and state management.

## Test Files

### 1. `home_repository_test.dart`
Tests for `HomeRepository` with ApiErrorHandler integration.

**Coverage:**
- ✅ Successful API calls
- ✅ Empty list handling
- ✅ Default pagination values
- ✅ DioException handling → ApiErrorModel
- ✅ Connection errors
- ✅ Timeout errors
- ✅ HTTP status codes (404, 401, 500, etc.)
- ✅ Generic exception handling
- ✅ Correct parameter passing to API service

**Total Tests:** 11

### 2. `home_cubit_test.dart`
Tests for `HomeCubit` with error state management.

**Coverage:**
- ✅ Initial state
- ✅ Loading breeds successfully
- ✅ Loading more breeds (pagination)
- ✅ Empty list → reachedEnd state
- ✅ ApiErrorModel catching
- ✅ Server error handling
- ✅ Refresh functionality
- ✅ loadMoreBreeds() conditions
- ✅ hasReachedEnd flag behavior
- ✅ Error scenarios (404, 401, 400, 500)

**Total Tests:** 22

### 3. `favorites_repository_test.dart`
Tests for `FavoritesRepository` with complete CRUD operations.

**Coverage:**
- ✅ Get favorites with pagination
- ✅ Create favorite with optimistic updates
- ✅ Delete favorite with rollback
- ✅ Boolean to int conversion for attachImage
- ✅ Error handling for all operations
- ✅ Network error handling
- ✅ HTTP status codes (401, 404, 500, etc.)

**Total Tests:** 20

### 4. `favorites_cubit_test.dart`
Tests for `FavoritesCubit` with optimistic updates.

**Coverage:**
- ✅ Initial state
- ✅ Load favorites successfully
- ✅ Add favorite with optimistic update
- ✅ Remove favorite with optimistic update
- ✅ Toggle favorite functionality
- ✅ Rollback on failure
- ✅ Reload after operations
- ✅ Error scenarios

**Total Tests:** 18

### 5. `api_error_model_test.dart`
Tests for the `ApiErrorModel` class.

**Coverage:**
- ✅ JSON parsing from various formats
- ✅ Status code handling (string and int)
- ✅ Icon assignment based on status codes
- ✅ Helper methods (isValidationError, isServerError, etc.)
- ✅ Error titles by status code
- ✅ toString() formatting

**Total Tests:** 28

### 6. `api_error_handler_test.dart`
Tests for `ApiErrorHandler` static methods.

**Coverage:**
- ✅ All DioException types handling
- ✅ Status code-based error handling (400-500)
- ✅ Response data parsing (JSON, String)
- ✅ Icon assignment for each status
- ✅ Edge cases (null data, empty data)
- ✅ Non-DioException handling

**Total Tests:** 25

### 7. `cache_helper_test.dart`
Tests for `CacheHelper` utility.

**Coverage:**
- ✅ Set and get String
- ✅ Set and get int
- ✅ Set and get double
- ✅ Set and get bool
- ✅ Set and get StringList
- ✅ Delete operations
- ✅ Clear all data
- ✅ Unsupported type handling

**Total Tests:** 15

### 8. `app_routes_test.dart`
Tests for app routing.

**Coverage:**
- ✅ Route generation
- ✅ Navigation to different screens
- ✅ Unknown route handling

**Total Tests:** 5

### 9. `favorite_model_test.dart`
Tests for favorite-related models.

**Coverage:**
- ✅ FavoriteModel JSON serialization
- ✅ FavoriteImageModel serialization
- ✅ CreateFavoriteRequest serialization
- ✅ CreateFavoriteResponse serialization
- ✅ includeIfNull behavior
- ✅ Roundtrip serialization

**Total Tests:** 20

### 10. `breed_model_test.dart`
Tests for breed-related models.

**Coverage:**
- ✅ BreedModel with all fields
- ✅ BreedModel with minimal fields
- ✅ WeightModel serialization
- ✅ Snake_case JSON key handling
- ✅ Nullable fields handling
- ✅ imageUrl getter logic
- ✅ Roundtrip serialization

**Total Tests:** 18

### 11. `favorites_state_test.dart`
Tests for `FavoritesState`.

**Coverage:**
- ✅ Initial state properties
- ✅ copyWith functionality
- ✅ isFavorite method
- ✅ getFavoriteId method
- ✅ Equatable implementation
- ✅ FavoritesStatus enum

**Total Tests:** 22

## Running the Tests

### Run all unit tests:
```bash
flutter test test/unit/
```

### Run specific test file:
```bash
flutter test test/unit/home_repository_test.dart
flutter test test/unit/home_cubit_test.dart
flutter test test/unit/favorites_cubit_test.dart
flutter test test/unit/api_error_handler_test.dart
```

### Run with coverage:
```bash
flutter test --coverage test/unit/
```

### Generate mocks (if needed):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
# or
dart run build_runner build --delete-conflicting-outputs
```

## Mock Generation

Tests use Mockito for mocking dependencies. Mocks are auto-generated from annotations:

```dart
@GenerateMocks([HomeApiService])
@GenerateMocks([HomeRepository])
@GenerateMocks([FavoritesApiService])
@GenerateMocks([FavoritesRepository])
```

Generated mock files:
- `home_repository_test.mocks.dart`
- `home_cubit_test.mocks.dart`
- `favorites_repository_test.mocks.dart`
- `favorites_cubit_test.mocks.dart`

## Test Structure

### Repository Tests Pattern
```dart
group('Repository', () {
  group('methodName', () {
    test('should return success when API call succeeds', () {
      // arrange
      when(mockApiService.method(any)).thenAnswer((_) async => data);
      
      // act
      final result = await repository.method();
      
      // assert
      expect(result, equals(Right(data)));
      verify(mockApiService.method(any)).called(1);
    });
    
    test('should return error when API call fails', () {
      // arrange
      when(mockApiService.method(any)).thenThrow(exception);
      
      // act
      final result = await repository.method();
      
      // assert
      expect(result.isLeft(), true);
    });
  });
});
```

### Cubit Tests Pattern (using bloc_test)
```dart
blocTest<MyCubit, MyState>(
  'description of what should happen',
  build: () {
    // Setup mocks
    when(mockRepo.method()).thenAnswer((_) async => data);
    return cubit;
  },
  seed: () => MyState(/* initial state */),
  act: (cubit) => cubit.method(),
  expect: () => [
    MyState(status: Status.loading),
    MyState(status: Status.success, data: data),
  ],
  verify: (_) {
    verify(mockRepo.method()).called(1);
  },
);
```

### Model Tests Pattern
```dart
group('Model', () {
  test('should create instance from JSON', () {
    // arrange
    final json = {'field': 'value'};
    
    // act
    final result = Model.fromJson(json);
    
    // assert
    expect(result.field, 'value');
  });
  
  test('should convert instance to JSON', () {
    // arrange
    final model = Model(field: 'value');
    
    // act
    final json = model.toJson();
    
    // assert
    expect(json['field'], 'value');
  });
});
```

## Error Handling Flow (Fully Tested)

```
1. API Error (Dio/Network)
   ↓
2. Repository catches → ApiErrorHandler.handle()
   ↓
3. ApiErrorModel created with:
   - User-friendly message
   - Status code
   - Appropriate icon
   ↓
4. Either<ApiErrorModel, Data> returned
   ↓
5. Cubit processes Either:
   - Left → emits failure state
   - Right → emits success state
   ↓
6. UI reacts to state changes
```

## Error Types Tested

### Network Errors:
- ✅ No internet connection
- ✅ Connection timeout
- ✅ Send timeout
- ✅ Receive timeout
- ✅ Bad certificate
- ✅ Request cancelled

### HTTP Errors:
- ✅ 400 Bad Request (Validation)
- ✅ 401 Unauthorized
- ✅ 403 Forbidden
- ✅ 404 Not Found
- ✅ 409 Conflict
- ✅ 422 Unprocessable Entity
- ✅ 500 Internal Server Error
- ✅ 503 Service Unavailable

### Generic Errors:
- ✅ Unknown exceptions
- ✅ Parsing errors
- ✅ Type errors

## Coverage Summary

| Component | Tests | Status |
|-----------|-------|--------|
| HomeRepository | 11 | ✅ Complete |
| HomeCubit | 22 | ✅ Complete |
| FavoritesRepository | 20 | ✅ Complete |
| FavoritesCubit | 18 | ✅ Complete |
| ApiErrorModel | 28 | ✅ Complete |
| ApiErrorHandler | 25 | ✅ Complete |
| CacheHelper | 15 | ✅ Complete |
| AppRoutes | 5 | ✅ Complete |
| FavoriteModel | 20 | ✅ Complete |
| BreedModel | 18 | ✅ Complete |
| FavoritesState | 22 | ✅ Complete |
| **Total** | **204** | ✅ Complete |

## Best Practices Demonstrated

1. **Arrange-Act-Assert Pattern**: Clear three-phase test structure
2. **Mock Isolation**: All dependencies are mocked for true unit testing
3. **Edge Cases**: Tests cover happy path, errors, and edge cases
4. **BLoC Testing**: Uses `bloc_test` package for cubit/bloc tests
5. **Verification**: Verifies mock interactions with `verify()` and `verifyNever()`
6. **Descriptive Names**: Test names clearly describe behavior being tested
7. **Group Organization**: Related tests are logically grouped
8. **Test Independence**: Each test can run independently
9. **Equatable Testing**: Tests equality and hashCode for state objects
10. **Roundtrip Testing**: Tests serialization → deserialization cycles

## Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.13
```

## CI/CD Integration

These tests can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test test/unit/ --coverage
      - uses: codecov/codecov-action@v2
```

## Test Execution Tips

### Run tests in parallel:
```bash
flutter test --concurrency=4
```

### Run tests with detailed output:
```bash
flutter test --verbose
```

### Run specific test group:
```bash
flutter test test/unit/home_cubit_test.dart --name "loadBreeds"
```

### Generate coverage report:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Open coverage/html/index.html in browser
```

## Troubleshooting

### Issue: Mock files not found
**Solution:** Run `dart run build_runner build --delete-conflicting-outputs`

### Issue: Tests fail with missing imports
**Solution:** Ensure all dependencies are installed with `flutter pub get`

### Issue: Equatable tests fail
**Solution:** Check that all properties are included in the `props` getter

### Issue: BlocTest timeout
**Solution:** Verify mock setup and that async operations complete

## Future Enhancements

- [ ] Add integration tests for full feature flows
- [ ] Add widget tests for error UI components
- [ ] Add golden tests for visual regression
- [ ] Test error analytics tracking
- [ ] Test retry mechanisms
- [ ] Performance tests for large datasets
- [ ] Test offline mode behavior
- [ ] Test state persistence

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [BlocTest Documentation](https://pub.dev/packages/bloc_test)
- [Equatable Documentation](https://pub.dev/packages/equatable)
- [Dartz (Functional Programming)](https://pub.dev/packages/dartz)
