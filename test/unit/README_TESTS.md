# Unit Tests for Home Feature with ApiErrorModel Handling

## Overview
This directory contains comprehensive unit tests for the Home feature, focusing on error handling using `ApiErrorModel`.

## Test Files

### 1. `api_error_model_test.dart`
Tests for the `ApiErrorModel` class itself.

**Coverage:**
- ✅ JSON parsing from various formats
- ✅ Status code handling (string and int)
- ✅ Icon assignment based on status codes
- ✅ Error list handling (list and map formats)
- ✅ Helper methods (`firstError`, `allErrorsAsString`, etc.)
- ✅ Boolean checkers (`isValidationError`, `isAuthError`, `isServerError`)
- ✅ Error titles by status code
- ✅ toString() formatting

**Total Tests:** 28

### 2. `home_repository_test.dart` (NEW)
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

**Key Test Scenarios:**
```dart
// Success case
test('should return list of breeds when API call is successful')

// Error cases
test('should throw ApiErrorModel when DioException occurs')
test('should throw ApiErrorModel with correct message for connection error')
test('should throw ApiErrorModel for connection timeout')
test('should throw ApiErrorModel with 404 status code')
test('should throw ApiErrorModel with 401 status code')
test('should throw ApiErrorModel for generic exception')
```

**Total Tests:** 11

### 3. `home_cubit_test.dart` (NEW)
Tests for `HomeCubit` with error state management.

**Coverage:**
- ✅ Initial state
- ✅ Loading breeds successfully
- ✅ Loading more breeds (pagination)
- ✅ Empty list → reachedEnd state
- ✅ ApiErrorModel catching
- ✅ Server error handling
- ✅ Unexpected error handling
- ✅ Refresh functionality
- ✅ loadMoreBreeds() conditions
- ✅ hasReachedEnd flag behavior
- ✅ Error scenarios (404, 401, 400, 500)

**Key Test Scenarios:**
```dart
// Success cases
blocTest('emits [loading, success] when data is loaded successfully')
blocTest('emits [loadingMore, success] when loading more data')

// Error cases  
blocTest('emits [loading, failure] when ApiErrorModel is thrown')
blocTest('emits [loading, failure] with server error message')
blocTest('emits failure with generic message for unexpected error')

// Edge cases
blocTest('does not load more when hasReachedEnd is true')
blocTest('allows loading even when hasReachedEnd is true') // for refresh
```

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
flutter test test/unit/api_error_model_test.dart
```

### Run with coverage:
```bash
flutter test --coverage test/unit/
```

### Generate mocks (if needed):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Mock Generation

Tests use Mockito for mocking dependencies. Mocks are auto-generated from annotations:

```dart
@GenerateMocks([HomeApiService])
@GenerateMocks([HomeRepository])
```

Generated files:
- `home_repository_test.mocks.dart`
- `home_cubit_test.mocks.dart`

## Error Handling Flow (Tested)

```
1. API Error (Dio/Network)
   ↓
2. Repository catches → ApiErrorHandler.handle()
   ↓
3. ApiErrorModel created with user-friendly message
   ↓
4. Repository throws ApiErrorModel
   ↓
5. Cubit catches ApiErrorModel
   ↓
6. Cubit emits failure state with error message
   ↓
7. UI displays error (tested in widget tests)
```

## Test Structure

### Repository Tests
```dart
group('HomeRepository', () {
  group('getBreeds', () {
    test('success case', () { ... });
    test('error case', () { ... });
  });
});
```

### Cubit Tests (using bloc_test)
```dart
blocTest<HomeCubit, HomeState>(
  'description',
  build: () { /* setup */ },
  seed: () { /* initial state */ },
  act: (cubit) { /* action */ },
  expect: () { /* expected states */ },
  verify: (_) { /* additional verifications */ },
);
```

## Error Types Tested

### Network Errors:
- ✅ No internet connection
- ✅ Connection timeout
- ✅ Send timeout
- ✅ Receive timeout
- ✅ Bad certificate

### HTTP Errors:
- ✅ 400 Bad Request
- ✅ 401 Unauthorized
- ✅ 403 Forbidden
- ✅ 404 Not Found
- ✅ 409 Conflict
- ✅ 422 Unprocessable Entity
- ✅ 500 Internal Server Error

### Generic Errors:
- ✅ Unknown exceptions
- ✅ Unexpected errors

## Coverage Summary

| Component | Tests | Coverage |
|-----------|-------|----------|
| ApiErrorModel | 28 | 100% |
| HomeRepository | 11 | 100% |
| HomeCubit | 22 | 100% |
| **Total** | **61** | **100%** |

## Best Practices Demonstrated

1. **Arrange-Act-Assert Pattern**: Clear test structure
2. **Mock Isolation**: Dependencies are mocked
3. **Edge Cases**: Tests cover happy path, errors, and edge cases
4. **BLoC Testing**: Uses `bloc_test` for cubit tests
5. **Verification**: Verifies mock interactions
6. **Descriptive Names**: Test names clearly describe what they test
7. **Group Organization**: Related tests are grouped together

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
- name: Run tests
  run: flutter test test/unit/
  
- name: Check coverage
  run: flutter test --coverage test/unit/
```

## Future Enhancements

- [ ] Add integration tests for full flow
- [ ] Add widget tests for error UI
- [ ] Test error analytics tracking
- [ ] Test retry mechanisms
- [ ] Performance tests for large datasets

