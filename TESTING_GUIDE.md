# Cat App Testing Guide

This guide provides comprehensive information about the testing setup and how to use it effectively.

## 📋 Table of Contents

- [Test Overview](#test-overview)
- [Quick Start](#quick-start)
- [Test Files](#test-files)
- [Running Tests](#running-tests)
- [Test Coverage](#test-coverage)
- [Writing Tests](#writing-tests)
- [CI/CD Integration](#cicd-integration)

## 🎯 Test Overview

The Cat App includes comprehensive test coverage with:

- **3 Unit Test Files** - Testing core business logic and utilities
- **4 Widget Test Files** - Testing UI components and screens
- **100+ Test Cases** - Covering various scenarios and edge cases

### Test Statistics

| Category | Files | Test Cases | Coverage Target |
|----------|-------|------------|-----------------|
| Unit Tests | 3 | 60+ | 80%+ |
| Widget Tests | 4 | 50+ | 70%+ |
| **Total** | **7** | **110+** | **75%+** |

## 🚀 Quick Start

### Prerequisites

1. Flutter SDK installed
2. Dependencies installed: `flutter pub get`

### Run All Tests

```bash
# Simple way
flutter test

# Using test runner (Unix/macOS/Linux)
./test_runner.sh all

# Using test runner (Windows)
test_runner.bat all
```

## 📁 Test Files

### Unit Tests (`test/unit/`)

#### 1. `cache_helper_test.dart`
Tests for the cache helper utility that manages SharedPreferences and FlutterSecureStorage.

**Test Coverage:**
- ✅ String storage and retrieval
- ✅ Integer storage and retrieval
- ✅ Double storage and retrieval
- ✅ Boolean storage and retrieval
- ✅ String list storage and retrieval
- ✅ Delete operations
- ✅ Clear all data
- ✅ Error handling for unsupported types

**Example Test:**
```dart
test('should save and retrieve string value', () async {
  const key = 'test_string';
  const value = 'test_value';

  await CacheHelper.set(key: key, value: value);
  final result = CacheHelper.getString(key: key);

  expect(result, value);
});
```

#### 2. `api_error_model_test.dart`
Tests for API error model parsing and error handling.

**Test Coverage:**
- ✅ JSON parsing with different formats
- ✅ Error list and map parsing
- ✅ Status code icon mapping
- ✅ Helper methods (firstError, allErrorsAsString)
- ✅ Boolean checks (isValidationError, isAuthError, isServerError)
- ✅ Error title generation

**Example Test:**
```dart
test('should parse error with list of errors', () {
  final json = {
    'message': 'Validation failed',
    'statusCode': 400,
    'errors': ['Error 1', 'Error 2', 'Error 3'],
  };

  final result = ApiErrorModel.fromJson(json);

  expect(result.message, 'Validation failed');
  expect(result.statusCode, 400);
  expect(result.errors.length, 3);
});
```

#### 3. `app_routes_test.dart`
Tests for application routing and navigation.

**Test Coverage:**
- ✅ Onboarding route generation
- ✅ Home route generation
- ✅ Unknown route handling
- ✅ Page not found display

**Example Test:**
```dart
test('should return OnboardingView for onboarding route', () {
  const settings = RouteSettings(name: Routes.onboarding);
  
  final route = appRoutes.generateRoute(settings);
  
  expect(route, isA<MaterialPageRoute>());
});
```

### Widget Tests (`test/widget/`)

#### 1. `primary_button_test.dart`
Tests for the PrimaryButton widget.

**Test Coverage:**
- ✅ Button text display
- ✅ Tap interaction
- ✅ Icon display
- ✅ Loading state
- ✅ Custom text color
- ✅ Default styling
- ✅ Full width layout
- ✅ Shadow and border radius

**Example Test:**
```dart
testWidgets('should call onTap when button is tapped', (tester) async {
  bool wasTapped = false;

  await tester.pumpWidget(
    _makeTestableWidget(
      child: PrimaryButton(
        text: 'Test Button',
        onTap: () {
          wasTapped = true;
        },
      ),
    ),
  );

  await tester.tap(find.byType(GestureDetector));
  await tester.pump();

  expect(wasTapped, true);
});
```

#### 2. `onboarding_view_test.dart`
Tests for the OnboardingView screen.

**Test Coverage:**
- ✅ Title and description display
- ✅ Image display
- ✅ Button display
- ✅ Navigation to home
- ✅ Layout structure
- ✅ Text alignment
- ✅ Widget ordering

**Example Test:**
```dart
testWidgets('should navigate to home when Get Started is tapped', 
  (tester) async {
    String? navigatedRoute;

    await tester.pumpWidget(
      _makeTestableWidgetWithNavigationObserver(
        onNavigate: (route) {
          navigatedRoute = route;
        },
      ),
    );

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(navigatedRoute, Routes.home);
  },
);
```

#### 3. `home_view_test.dart`
Tests for the HomeView screen.

**Test Coverage:**
- ✅ Text display
- ✅ Scaffold structure
- ✅ Center widget
- ✅ Widget type verification

**Example Test:**
```dart
testWidgets('should display Home text', (tester) async {
  await tester.pumpWidget(_makeTestableWidget());

  expect(find.text('Home'), findsOneWidget);
});
```

#### 4. `cat_app_test.dart`
Tests for the main CatApp widget.

**Test Coverage:**
- ✅ MaterialApp configuration
- ✅ ScreenUtilInit setup
- ✅ Theme configuration
- ✅ Route generation
- ✅ Initial route
- ✅ Navigation behavior
- ✅ Material 3 usage
- ✅ Color scheme

**Example Test:**
```dart
testWidgets('should navigate to onboarding as initial route', 
  (tester) async {
    await tester.pumpWidget(const CatApp(appRoutes: AppRoutes()));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingView), findsOneWidget);
  },
);
```

## 🏃 Running Tests

### Command Line

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/cache_helper_test.dart

# Run all unit tests
flutter test test/unit/

# Run all widget tests
flutter test test/widget/

# Run with coverage
flutter test --coverage

# Run in watch mode
flutter test --watch

# Run test suite
flutter test test/test_suite.dart
```

### Using Test Runner Scripts

#### Unix/macOS/Linux

```bash
# Make script executable (first time only)
chmod +x test_runner.sh

# Run all tests
./test_runner.sh all

# Run unit tests only
./test_runner.sh unit

# Run widget tests only
./test_runner.sh widget

# Generate coverage
./test_runner.sh coverage

# Generate HTML coverage report
./test_runner.sh html

# Clean test artifacts
./test_runner.sh clean

# Watch mode
./test_runner.sh watch
```

#### Windows

```cmd
# Run all tests
test_runner.bat all

# Run unit tests only
test_runner.bat unit

# Run widget tests only
test_runner.bat widget

# Generate coverage
test_runner.bat coverage

# Clean test artifacts
test_runner.bat clean

# Watch mode
test_runner.bat watch
```

### VS Code Integration

Add to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter: Run All Tests",
      "type": "dart",
      "request": "launch",
      "program": "test/test_suite.dart"
    }
  ]
}
```

## 📊 Test Coverage

### Viewing Coverage

1. **Generate Coverage Report:**
   ```bash
   flutter test --coverage
   ```

2. **View lcov.info:** The raw coverage data is in `coverage/lcov.info`

3. **Generate HTML Report (requires lcov):**
   ```bash
   # Install lcov
   # macOS: brew install lcov
   # Ubuntu/Debian: sudo apt-get install lcov
   
   # Generate HTML
   genhtml coverage/lcov.info -o coverage/html
   
   # Open in browser
   open coverage/html/index.html  # macOS
   start coverage/html/index.html  # Windows
   ```

### Coverage Goals

- **Overall Coverage:** 75%+
- **Unit Tests:** 80%+
- **Widget Tests:** 70%+

## ✍️ Writing Tests

### Unit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/your_file.dart';

void main() {
  group('ComponentName', () {
    setUp(() {
      // Setup code that runs before each test
    });

    tearDown(() {
      // Cleanup code that runs after each test
    });

    test('should perform expected behavior', () {
      // Arrange - Set up test data
      const input = 'test';
      
      // Act - Execute the code being tested
      final result = yourFunction(input);
      
      // Assert - Verify the results
      expect(result, 'expected_output');
    });
  });
}
```

### Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_app/your_widget.dart';

void main() {
  group('WidgetName Widget Tests', () {
    testWidgets('should display expected content', (tester) async {
      // Arrange
      await tester.pumpWidget(_makeTestableWidget());

      // Assert
      expect(find.text('Expected Text'), findsOneWidget);
    });

    testWidgets('should respond to user interaction', (tester) async {
      // Arrange
      bool wasPressed = false;
      await tester.pumpWidget(
        _makeTestableWidget(
          onPressed: () => wasPressed = true,
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(wasPressed, true);
    });
  });
}

Widget _makeTestableWidget({VoidCallback? onPressed}) {
  return MaterialApp(
    home: Scaffold(
      body: YourWidget(onPressed: onPressed),
    ),
  );
}
```

### Best Practices

1. **Use Descriptive Names**: Test names should clearly describe what is being tested
   ```dart
   test('should return validation error when email is invalid', () {});
   ```

2. **Follow AAA Pattern**: Arrange, Act, Assert
   ```dart
   test('example', () {
     // Arrange
     final input = 'test';
     
     // Act
     final result = function(input);
     
     // Assert
     expect(result, expected);
   });
   ```

3. **Test One Thing**: Each test should verify one specific behavior

4. **Use setUp and tearDown**: For common initialization and cleanup

5. **Mock External Dependencies**: Use mockito for mocking

6. **Test Edge Cases**: Don't just test happy paths

## 🔄 CI/CD Integration

### GitHub Actions

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.2'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### GitLab CI

Create `.gitlab-ci.yml`:

```yaml
stages:
  - test

test:
  stage: test
  image: cirrusci/flutter:stable
  script:
    - flutter pub get
    - flutter test --coverage
  coverage: '/lines\.*: \d+\.\d+%/'
  artifacts:
    paths:
      - coverage/
```

## 🐛 Troubleshooting

### Common Issues

1. **Asset Loading Errors**
   - Solution: Ensure assets are properly defined in `pubspec.yaml`
   - Use `flutter pub get` to refresh assets

2. **Platform Channel Errors**
   - Solution: Mock platform channels in tests
   ```dart
   TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
     .setMockMethodCallHandler(channel, handler);
   ```

3. **Async/Await Issues**
   - Use `pumpAndSettle()` for animations
   - Use `pump()` for single frame updates

4. **ScreenUtil Errors**
   - Wrap test widgets with `ScreenUtilInit`
   ```dart
   ScreenUtilInit(
     designSize: const Size(375, 812),
     builder: (context, _) => MaterialApp(home: YourWidget()),
   )
   ```

## 📚 Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Unit Testing Guide](https://docs.flutter.dev/cookbook/testing/unit/introduction)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Flutter Test Package](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)

## 📝 Notes

- Tests are automatically discovered by Flutter when placed in the `test/` directory
- Test files should end with `_test.dart`
- Use `testWidgets` for widget tests and `test` for unit tests
- Always clean up resources in `tearDown()` or `tearDownAll()`
- Run tests before committing to ensure code quality

---

**Happy Testing! 🎉**

