# Integration Tests

This directory contains comprehensive integration tests for the Cat App. Integration tests verify the complete user journey and interactions across multiple screens and features.

## Test Structure

```
integration_test/
├── app_test.dart                        # Main app flow and navigation tests
├── onboarding_integration_test.dart     # Onboarding screen tests
├── home_integration_test.dart           # Home screen and breed list tests
├── favorites_integration_test.dart      # Favorites feature tests
├── breed_details_integration_test.dart  # Breed details screen tests
└── README.md                            # This file
```

## What are Integration Tests?

Integration tests (also called end-to-end or E2E tests) run the complete app and test user flows from start to finish. Unlike unit tests that test individual functions, or widget tests that test individual screens, integration tests verify that all parts of the app work together correctly.

### Benefits of Integration Tests

- ✅ Test real user scenarios and workflows
- ✅ Catch issues with navigation and state management
- ✅ Verify API integration and data flow
- ✅ Ensure features work together correctly
- ✅ Build confidence before releases

## Running Integration Tests

### Prerequisites

- Flutter SDK installed and configured
- A connected device or running emulator/simulator
- App dependencies installed (`flutter pub get`)

### Run All Tests

**Windows:**
```bash
run_integration_tests.bat
```

**macOS/Linux:**
```bash
chmod +x run_integration_tests.sh
./run_integration_tests.sh
```

**Or using Flutter command:**
```bash
flutter test integration_test
```

### Run Specific Test File

**Windows:**
```bash
run_integration_tests.bat app_test.dart
```

**macOS/Linux:**
```bash
./run_integration_tests.sh app_test.dart
```

**Or using Flutter command:**
```bash
flutter test integration_test/app_test.dart
flutter test integration_test/onboarding_integration_test.dart
flutter test integration_test/home_integration_test.dart
flutter test integration_test/favorites_integration_test.dart
flutter test integration_test/breed_details_integration_test.dart
```

### Run on Specific Device

```bash
# List available devices
flutter devices

# Run on specific device
flutter test integration_test --device-id=<device_id>
```

### Run with Driver (for real devices)

For more complex scenarios or running on physical devices, use the integration test driver:

```bash
flutter drive \
  --driver=integration_test_driver.dart \
  --target=integration_test/app_test.dart
```

## Test Coverage

### 1. App Flow Tests (`app_test.dart`)

Tests the main application flow and navigation:

- ✅ App launches successfully
- ✅ Complete user flow from onboarding to home
- ✅ Navigation between tabs (Home, Favorites, Chat, Profile)
- ✅ Error handling and graceful failures

**Key Scenarios:**
```dart
- App launches and loads initial screen
- Navigate from onboarding to main navigation
- Switch between bottom navigation tabs
- App handles navigation without crashes
```

### 2. Onboarding Tests (`onboarding_integration_test.dart`)

Tests the onboarding screen functionality:

- ✅ Onboarding content display (image, title, description)
- ✅ Get Started button functionality
- ✅ Navigation to main navigation
- ✅ One-time flow (cannot navigate back)
- ✅ Screen layout and UI components

**Key Scenarios:**
```dart
- Display onboarding content correctly
- Navigate to main app on button tap
- Cannot go back to onboarding after proceeding
- Button responds to user interaction
```

### 3. Home Screen Tests (`home_integration_test.dart`)

Tests the home screen and breed listing functionality:

- ✅ Home screen loads main components
- ✅ Breed cards display after loading
- ✅ Loading, error, and success states
- ✅ Search bar visibility and interaction
- ✅ Category list display
- ✅ Scrolling through breed list
- ✅ Pull-to-refresh functionality
- ✅ Pagination (loading more breeds)
- ✅ Navigation to breed details

**Key Scenarios:**
```dart
- Home screen displays search bar and categories
- Breed list loads and displays cards
- Scroll through breeds and trigger pagination
- Pull to refresh reloads breeds
- Tap breed card to view details
- Handle loading and error states
```

### 4. Favorites Tests (`favorites_integration_test.dart`)

Tests the favorites feature functionality:

- ✅ Navigate to favorites from bottom navigation
- ✅ Empty state display (no favorites)
- ✅ Loading state handling
- ✅ Add/remove favorites
- ✅ Favorites persistence across navigation
- ✅ List interaction (scroll, tap)
- ✅ Pull-to-refresh
- ✅ Navigation to breed details from favorites

**Key Scenarios:**
```dart
- Navigate to favorites screen
- Display empty state when no favorites
- Toggle favorite status from details screen
- Favorites persist when navigating away and back
- Scroll through favorites list
- Pull to refresh favorites
```

### 5. Breed Details Tests (`breed_details_integration_test.dart`)

Tests the breed details screen functionality:

- ✅ Navigate to details from home screen
- ✅ Display breed information (name, description, etc.)
- ✅ Display breed image
- ✅ Scroll through details content
- ✅ Toggle favorite status
- ✅ Favorite status persistence
- ✅ Display characteristics and stats
- ✅ Handle missing information gracefully
- ✅ Navigate back to previous screen

**Key Scenarios:**
```dart
- Open breed details from home
- Display all breed information sections
- Toggle favorite from details screen
- Scroll through breed details
- Navigate back to home
- View multiple breeds sequentially
```

## Writing New Integration Tests

### Basic Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cat_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Feature Name', () {
    testWidgets('Test description', (tester) async {
      // Start the app
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding if needed
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Your test code here
      // ...

      // Assertions
      expect(find.something, findsOneWidget);
    });
  });
}
```

### Best Practices

1. **Initialize Integration Test Binding**
   ```dart
   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
   ```

2. **Use Appropriate Wait Times**
   ```dart
   await tester.pumpAndSettle(const Duration(seconds: 3));
   ```

3. **Handle Onboarding State**
   ```dart
   final getStartedButton = find.text('Get Started');
   if (tester.any(getStartedButton)) {
     await tester.tap(getStartedButton);
     await tester.pumpAndSettle(const Duration(seconds: 3));
   }
   ```

4. **Check Element Existence Before Interaction**
   ```dart
   if (tester.any(find.byType(ListView))) {
     await tester.drag(find.byType(ListView).first, const Offset(0, -300));
   }
   ```

5. **Use Descriptive Test Names**
   ```dart
   testWidgets('Navigate to favorites screen from bottom navigation', ...);
   ```

6. **Group Related Tests**
   ```dart
   group('Home Screen - Display', () { ... });
   group('Home Screen - Search', () { ... });
   ```

7. **Handle Asynchronous Operations**
   ```dart
   await tester.pumpAndSettle(const Duration(seconds: 5));
   ```

## Common Integration Test Patterns

### Navigation Test
```dart
testWidgets('Navigate between screens', (tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  
  // Tap navigation element
  await tester.tap(find.byIcon(Icons.favorite));
  await tester.pumpAndSettle();
  
  // Verify navigation
  expect(find.text('Favorites'), findsOneWidget);
});
```

### User Interaction Test
```dart
testWidgets('User can interact with element', (tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  
  // Find and tap element
  final button = find.text('Get Started');
  await tester.tap(button);
  await tester.pumpAndSettle();
  
  // Verify result
  expect(find.text('Home'), findsOneWidget);
});
```

### Scrolling Test
```dart
testWidgets('User can scroll through list', (tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  
  final listView = find.byType(ListView);
  await tester.drag(listView, const Offset(0, -300));
  await tester.pumpAndSettle();
  
  // Verify scroll occurred (check for new items, etc.)
});
```

### State Persistence Test
```dart
testWidgets('State persists across navigation', (tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  
  // Change state
  await tester.tap(find.byIcon(Icons.favorite));
  await tester.pumpAndSettle();
  
  // Navigate away
  await tester.tap(find.byIcon(Icons.home));
  await tester.pumpAndSettle();
  
  // Navigate back
  await tester.tap(find.byIcon(Icons.favorite));
  await tester.pumpAndSettle();
  
  // Verify state persisted
  expect(find.byIcon(Icons.favorite), findsWidgets);
});
```

## Debugging Integration Tests

### Enable Debug Output
```dart
testWidgets('Test with debug output', (tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  
  // Print widget tree
  debugDumpApp();
  
  // Print render tree
  debugDumpRenderTree();
  
  // Print specific widget
  final widget = tester.widget(find.byType(Text));
  print(widget);
});
```

### Take Screenshots
```dart
testWidgets('Test with screenshots', (tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  
  // Take screenshot (requires integration_test package)
  await binding.takeScreenshot('screenshot_name');
});
```

### Increase Timeout
```dart
testWidgets('Long running test', (tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 10));
  
  // Long operations...
}, timeout: const Timeout(Duration(minutes: 5)));
```

## Common Issues and Solutions

### Issue: Test times out waiting for widget

**Solution:** Increase wait time or use pump instead of pumpAndSettle
```dart
await tester.pumpAndSettle(const Duration(seconds: 10));
// or
await tester.pump(const Duration(seconds: 5));
```

### Issue: Widget not found

**Solution:** Check if widget exists before interacting
```dart
if (tester.any(find.text('Button'))) {
  await tester.tap(find.text('Button'));
}
```

### Issue: Multiple widgets found

**Solution:** Use `.first`, `.last`, or `.at(index)`
```dart
await tester.tap(find.byIcon(Icons.favorite).first);
```

### Issue: Navigation doesn't work

**Solution:** Ensure you wait for navigation to complete
```dart
await tester.tap(find.text('Navigate'));
await tester.pumpAndSettle(const Duration(seconds: 3));
```

### Issue: Real API calls fail during tests

**Solution:** Consider mocking API calls or use test endpoints
```dart
// In your test setup
setUp(() {
  // Mock API setup
});
```

## Continuous Integration

### GitHub Actions Example
```yaml
name: Integration Tests
on: [push, pull_request]

jobs:
  integration-tests:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter test integration_test
```

## Performance Considerations

- Integration tests are slower than unit tests (30s - 2min per test)
- Run on CI/CD pipeline for pull requests
- Run locally before major releases
- Focus on critical user paths
- Keep test count manageable (5-15 key scenarios)

## Next Steps

1. Run the tests on a real device to verify actual user experience
2. Add more edge case scenarios as needed
3. Integrate tests into your CI/CD pipeline
4. Monitor test execution time and optimize if needed
5. Update tests when adding new features

## Resources

- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Integration Test Package](https://pub.dev/packages/integration_test)
- [Flutter Testing Best Practices](https://docs.flutter.dev/testing/best-practices)

---

**Happy Testing! 🧪**

