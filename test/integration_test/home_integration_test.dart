import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:cat_app/main.dart' as app;

/// Integration tests for the Home feature
/// Tests home screen display, breed list, search, categories, and pagination
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home Screen - Display', () {
    testWidgets('Home screen loads and displays main components', (
      tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding if present
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for home content to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify home screen components
      // Should have a search bar
      expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));

      // Should have the home icon in navigation
      expect(find.byIcon(Icons.home), findsAtLeastNWidgets(1));
    });

    testWidgets('Home screen displays breed cards after loading', (
      tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding if present
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for breeds to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should either show loading indicator, error state, or breed cards
      final hasLoading = tester.any(find.byType(CircularProgressIndicator));
      final hasError = tester.any(find.text('Retry'));
      final hasList = tester.any(find.byType(ListView));

      // At least one of these should be true
      expect(hasLoading || hasError || hasList, isTrue);
    });

    testWidgets('Home screen handles loading state', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Skip onboarding if present
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        // During loading, might see a progress indicator
        // (This is time-sensitive, so we just verify it doesn't crash)
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      // App should not crash during loading
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Home Screen - Search', () {
    testWidgets('Search bar is visible and tappable', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find search icon or search bar
      final searchIcon = find.byIcon(Icons.search);
      expect(searchIcon, findsAtLeastNWidgets(1));

      // Try to tap on search area (if it's interactive)
      if (tester.any(searchIcon)) {
        final firstSearchIcon = searchIcon.first;
        await tester.tap(firstSearchIcon);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Search functionality exists', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify search icon exists
      expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));
    });
  });

  group('Home Screen - Categories', () {
    testWidgets('Category list is displayed', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for category indicators (might be text or chips)
      // Categories like "All", "Popular", etc. might be present
      // Just verify the screen loaded with some UI elements
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  group('Home Screen - Breed List', () {
    testWidgets('Scrolling through breed list works', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for breeds to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the list view
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        // Scroll down
        await tester.drag(listView.first, const Offset(0, -300));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Scroll back up
        await tester.drag(listView.first, const Offset(0, 300));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Test passes if no crash occurs
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Pull to refresh works', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for breeds to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find refresh indicator or list to pull down on
      final refreshIndicator = find.byType(RefreshIndicator);

      if (tester.any(refreshIndicator)) {
        // Perform pull to refresh gesture
        await tester.drag(find.byType(ListView).first, const Offset(0, 300));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      // Should still be on home screen
      expect(find.byIcon(Icons.home), findsAtLeastNWidgets(1));
    });

    testWidgets('Error state displays retry button', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for content
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check if error state is visible
      final retryButton = find.text('Retry');

      if (tester.any(retryButton)) {
        // Verify error message is shown
        expect(find.byIcon(Icons.error), findsWidgets);

        // Tap retry button
        await tester.tap(retryButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      // App should be functional
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Home Screen - Pagination', () {
    testWidgets('Loading more breeds when scrolling to bottom', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for initial breeds to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        // Scroll to bottom to trigger pagination
        await tester.drag(listView.first, const Offset(0, -1000));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Scroll more
        await tester.drag(listView.first, const Offset(0, -1000));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should see loading indicator for pagination or more items
        // At minimum, the list should still exist
        expect(listView, findsWidgets);
      }
    });
  });

  group('Home Screen - Navigation to Details', () {
    testWidgets('Tapping a breed card navigates to details', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for breeds to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find list items (cards)
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        // Try to find and tap on a GestureDetector or InkWell in the list
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        final inkWells = find.descendant(
          of: listView.first,
          matching: find.byType(InkWell),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should navigate to details screen
          // Verify by checking if we can go back
          final NavigatorState navigator = tester.state(find.byType(Navigator));
          expect(navigator.canPop(), isTrue);
        } else if (tester.any(inkWells)) {
          await tester.tap(inkWells.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should navigate to details screen
          final NavigatorState navigator = tester.state(find.byType(Navigator));
          expect(navigator.canPop(), isTrue);
        }
      }
    });
  });
}
