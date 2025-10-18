# Cat App Tests

This directory contains comprehensive unit tests and widget tests for the Cat App.

## Test Structure

```
test/
├── unit/                      # Unit tests
│   ├── cache_helper_test.dart
│   ├── api_error_model_test.dart
│   └── app_routes_test.dart
├── widget/                    # Widget tests
│   ├── primary_button_test.dart
│   ├── onboarding_view_test.dart
│   ├── home_view_test.dart
│   ├── cat_app_test.dart
│   ├── pet_card_widget_test.dart
│   ├── favorite_icon_test.dart
│   ├── search_bar_widget_test.dart
│   ├── category_chip_widget_test.dart
│   ├── breed_details_view_test.dart
│   └── favorites_view_test.dart
├── test_suite.dart           # Main test suite
└── README.md                 # This file
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
# Unit tests
flutter test test/unit/cache_helper_test.dart
flutter test test/unit/api_error_model_test.dart
flutter test test/unit/app_routes_test.dart

# Widget tests
flutter test test/widget/primary_button_test.dart
flutter test test/widget/onboarding_view_test.dart
flutter test test/widget/home_view_test.dart
flutter test test/widget/cat_app_test.dart
flutter test test/widget/pet_card_widget_test.dart
flutter test test/widget/favorite_icon_test.dart
flutter test test/widget/search_bar_widget_test.dart
flutter test test/widget/category_chip_widget_test.dart
flutter test test/widget/breed_details_view_test.dart
flutter test test/widget/favorites_view_test.dart
```

### Run Test Suite
```bash
flutter test test/test_suite.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Report (requires lcov)
```bash
# Generate coverage
flutter test --coverage

# Generate HTML report (requires genhtml from lcov package)
genhtml coverage/lcov.info -o coverage/html

# Open report in browser
open coverage/html/index.html  # macOS
start coverage/html/index.html  # Windows
xdg-open coverage/html/index.html  # Linux
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

## Test Categories

### Unit Tests

1. **CacheHelper Tests** (`unit/cache_helper_test.dart`)
   - Tests for storing and retrieving different data types
   - Tests for deleting data
   - Tests for clearing all data
   - Tests for error handling

2. **ApiErrorModel Tests** (`unit/api_error_model_test.dart`)
   - Tests for parsing JSON responses
   - Tests for different error formats
   - Tests for error status codes
   - Tests for helper methods

3. **AppRoutes Tests** (`unit/app_routes_test.dart`)
   - Tests for route generation
   - Tests for navigation to different screens
   - Tests for handling unknown routes

### Widget Tests

1. **PrimaryButton Tests** (`widget/primary_button_test.dart`)
   - Tests for button display
   - Tests for tap interactions
   - Tests for loading state
   - Tests for icon display
   - Tests for custom colors

2. **OnboardingView Tests** (`widget/onboarding_view_test.dart`)
   - Tests for onboarding content display
   - Tests for navigation
   - Tests for layout structure

3. **HomeView Tests** (`widget/home_view_test.dart`)
   - Tests for home screen display
   - Tests for widget structure

4. **CatApp Tests** (`widget/cat_app_test.dart`)
   - Tests for app configuration
   - Tests for theming
   - Tests for routing
   - Tests for initial route

5. **PetCardWidget Tests** (`widget/pet_card_widget_test.dart`)
   - Tests for breed information display
   - Tests for image handling
   - Tests for favorite icon
   - Tests for tap interactions
   - Tests for navigation
   - Tests for conditional rendering

6. **FavoriteIcon Tests** (`widget/favorite_icon_test.dart`)
   - Tests for icon state (favorited/not favorited)
   - Tests for toggle favorite functionality
   - Tests for BLoC integration
   - Tests for icon styling

7. **SearchBarWidget Tests** (`widget/search_bar_widget_test.dart`)
   - Tests for search input field
   - Tests for search icon
   - Tests for filter button
   - Tests for hint text
   - Tests for text input handling

8. **CategoryChipWidget Tests** (`widget/category_chip_widget_test.dart`)
   - Tests for label display
   - Tests for selected/unselected states
   - Tests for tap interactions
   - Tests for styling changes
   - Tests for border and colors

9. **BreedDetailsView Tests** (`widget/breed_details_view_test.dart`)
   - Tests for breed information sections
   - Tests for SliverAppBar
   - Tests for back navigation
   - Tests for favorite functionality
   - Tests for conditional widget display
   - Tests for layout structure

10. **FavoritesView Tests** (`widget/favorites_view_test.dart`)
    - Tests for empty state
    - Tests for loading state
    - Tests for error state
    - Tests for favorites grid display
    - Tests for category tabs
    - Tests for pull to refresh
    - Tests for retry functionality

## Test Coverage

To ensure high-quality code, aim for:
- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 70%+ coverage
- **Overall**: 75%+ coverage

## Writing New Tests

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ComponentName', () {
    setUp(() {
      // Setup code here
    });

    tearDown(() {
      // Cleanup code here
    });

    test('should do something', () {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetName Widget Tests', () {
    testWidgets('should display something', (tester) async {
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.text('Something'), findsOneWidget);
    });
  });
}

Widget _makeTestableWidget() {
  return const MaterialApp(
    home: YourWidget(),
  );
}
```

## Best Practices

1. **Arrange-Act-Assert**: Structure your tests with clear setup, execution, and verification phases
2. **Descriptive Names**: Use clear, descriptive test names that explain what is being tested
3. **Single Responsibility**: Each test should verify one specific behavior
4. **Use Finders**: Use Flutter's finder utilities for locating widgets
5. **Pump and Settle**: Use `pumpAndSettle()` for animations and async operations
6. **Mock Dependencies**: Mock external dependencies to isolate the code under test
7. **Test Edge Cases**: Don't just test the happy path

## Continuous Integration

These tests can be integrated into your CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v2
```

## Troubleshooting

### Common Issues

1. **Asset Loading Errors**: Make sure to use proper asset paths in tests
2. **Platform Channel Errors**: Mock platform channels when testing platform-specific code
3. **Async Issues**: Use `pumpAndSettle()` or `pump()` appropriately for async operations
4. **Screen Size Issues**: Use `ScreenUtilInit` wrapper in widget tests that use responsive sizing

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Unit Testing](https://docs.flutter.dev/cookbook/testing/unit/introduction)
- [Mockito Documentation](https://pub.dev/packages/mockito)

