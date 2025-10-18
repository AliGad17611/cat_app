# Cat App Tests

This directory contains comprehensive unit tests and widget tests for the Cat App.

## Test Structure

```
test/
├── unit/                      # Unit tests
│   ├── home_repository_test.dart
│   ├── home_cubit_test.dart
│   ├── favorites_repository_test.dart
│   ├── favorites_cubit_test.dart
│   ├── favorite_model_test.dart
│   ├── breed_model_test.dart
│   ├── favorites_state_test.dart
│   ├── api_error_model_test.dart
│   ├── api_error_handler_test.dart
│   ├── cache_helper_test.dart
│   ├── app_routes_test.dart
│   └── README_TESTS.md        # Detailed unit test documentation
├── widget/                    # Widget tests
│   ├── primary_button_test.dart
│   ├── onboarding_view_test.dart
│   ├── home_view_test.dart
│   └── cat_app_test.dart
├── test_suite.dart           # Main test suite
└── README.md                 # This file
```

## Quick Start

### Run All Tests
```bash
flutter test
```

### Run Unit Tests Only
```bash
flutter test test/unit/
```

### Run Widget Tests Only
```bash
flutter test test/widget/
```

### Run Specific Test File
```bash
flutter test test/unit/home_cubit_test.dart
flutter test test/widget/primary_button_test.dart
```

### Run with Coverage
```bash
flutter test --coverage
```

### Generate Coverage Report (HTML)
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Then open coverage/html/index.html in your browser
```

## Test Categories

### Unit Tests (204 tests)

Tests for business logic, repositories, cubits, models, and utilities without UI dependencies.

**Key Areas Covered:**
- **Repositories** (31 tests): API interactions, error handling, data transformation
- **Cubits** (40 tests): State management, business logic, event handling
- **Models** (38 tests): Data serialization/deserialization, validation
- **Error Handling** (53 tests): ApiErrorModel, ApiErrorHandler, error mapping
- **Utilities** (20 tests): CacheHelper, routing, helpers
- **State Management** (22 tests): State classes, copyWith, Equatable

**Coverage:**
- Home feature: 100%
- Favorites feature: 100%
- Error handling: 100%
- Models: 100%
- Utilities: 100%

See [test/unit/README_TESTS.md](unit/README_TESTS.md) for detailed documentation.

### Widget Tests (15+ tests)

Tests for UI components and screens with widget interactions.

**Key Areas Covered:**
- Primary button widget (states, interactions, customization)
- Onboarding screen (layout, navigation)
- Home screen (structure, widgets)
- App configuration (theming, routing, initialization)

## Test Execution

### Using Test Scripts

**Windows:**
```bash
test_runner.bat
```

**Unix/Linux/Mac:**
```bash
./test_runner.sh
```

### Manual Execution

**Run tests in parallel:**
```bash
flutter test --concurrency=4
```

**Run with verbose output:**
```bash
flutter test --verbose
```

**Run specific test by name:**
```bash
flutter test --name "should load breeds successfully"
```

**Run tests with reporting:**
```bash
flutter test --reporter expanded
```

## Mock Generation

This project uses Mockito for test mocks. To regenerate mocks after changing dependencies:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or watch mode for continuous regeneration:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Test Coverage

### Current Coverage
- **Overall**: 75%+
- **Unit Tests**: 80%+
- **Widget Tests**: 70%+

### Coverage Goals
- Unit Tests: 80%+ ✅
- Widget Tests: 70%+ ✅
- Overall: 75%+ ✅

### View Coverage Report
After running tests with `--coverage`, open the HTML report:

**Windows:**
```bash
start coverage/html/index.html
```

**Mac:**
```bash
open coverage/html/index.html
```

**Linux:**
```bash
xdg-open coverage/html/index.html
```

## Writing New Tests

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ComponentName', () {
    late MyComponent component;

    setUp(() {
      // Setup code before each test
      component = MyComponent();
    });

    tearDown(() {
      // Cleanup code after each test
    });

    test('should do something', () {
      // Arrange
      final input = 'test';

      // Act
      final result = component.doSomething(input);

      // Assert
      expect(result, 'expected');
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

### Cubit/Bloc Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('MyCubit', () {
    late MyCubit cubit;

    setUp(() {
      cubit = MyCubit();
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<MyCubit, MyState>(
      'description of behavior',
      build: () => cubit,
      act: (cubit) => cubit.doSomething(),
      expect: () => [
        MyState(status: Status.loading),
        MyState(status: Status.success),
      ],
    );
  });
}
```

## Best Practices

1. **Follow AAA Pattern**: Arrange, Act, Assert
2. **Test Behavior, Not Implementation**: Focus on what, not how
3. **One Assertion Per Test**: Keep tests focused
4. **Use Descriptive Names**: Test names should explain what they test
5. **Mock External Dependencies**: Isolate the code under test
6. **Test Edge Cases**: Don't just test the happy path
7. **Keep Tests Fast**: Unit tests should run in milliseconds
8. **Avoid Test Interdependence**: Each test should be independent
9. **Use setUp and tearDown**: Keep tests clean and organized
10. **Test Error Cases**: Verify error handling works correctly

## Continuous Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.2'
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v2
```

### GitLab CI Example
```yaml
test:
  stage: test
  script:
    - flutter pub get
    - flutter test --coverage
  coverage: '/lines\.*: \d+\.\d+%/'
```

## Dependencies

### Production
```yaml
dependencies:
  flutter_bloc: ^9.1.1
  dartz: ^0.10.1
  dio: ^5.9.0
  equatable: ^2.0.7
```

### Testing
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.13
```

## Troubleshooting

### Common Issues

**Issue: Tests fail with "No tests found"**
```bash
# Solution: Check test file naming (must end with _test.dart)
# Ensure test files are in test/ directory
```

**Issue: Mock generation fails**
```bash
# Solution: Clean and regenerate
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Issue: Widget tests fail with "Null check operator used on a null value"**
```bash
# Solution: Ensure TestWidgetsFlutterBinding is initialized
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // ... tests
}
```

**Issue: Tests timeout**
```bash
# Solution: Increase timeout or check for infinite loops
testWidgets('test', (tester) async {
  // ...
}, timeout: Timeout(Duration(seconds: 60)));
```

**Issue: Coverage report not generated**
```bash
# Solution: Ensure lcov is installed
# Mac: brew install lcov
# Linux: sudo apt-get install lcov
# Windows: Download from http://ltp.sourceforge.net/coverage/lcov.php
```

## Test Performance

### Current Performance
- **Total Tests**: 219+
- **Execution Time**: ~10-15 seconds
- **Average per Test**: ~50ms

### Optimization Tips
1. Use `setUp` and `tearDown` efficiently
2. Avoid heavy computations in tests
3. Mock expensive operations
4. Run tests in parallel (`--concurrency`)
5. Use `pumpAndSettle()` judiciously in widget tests

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Cookbook](https://docs.flutter.dev/cookbook/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [BlocTest Documentation](https://pub.dev/packages/bloc_test)
- [Test Coverage Best Practices](https://docs.flutter.dev/testing/code-coverage)

## Contributing

When adding new features, please:
1. Write unit tests for business logic
2. Write widget tests for UI components
3. Ensure coverage stays above 75%
4. Follow existing test patterns
5. Update documentation as needed

## Questions?

For questions about tests, check:
1. This README
2. [test/unit/README_TESTS.md](unit/README_TESTS.md)
3. Example tests in test/unit/ and test/widget/
4. Team documentation
