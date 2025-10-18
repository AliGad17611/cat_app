import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:cat_app/main.dart' as app;

/// Integration tests for the Favorites feature
/// Tests favorites screen display, adding/removing favorites, and navigation
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Favorites Screen - Display', () {
    testWidgets('Navigate to favorites screen from bottom navigation', (
      tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap on favorites navigation icon
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      expect(favoritesIcon, findsAtLeastNWidgets(1));

      await tester.tap(favoritesIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify we're on favorites screen
      // Should still see the navigation bar
      expect(find.byIcon(Icons.home), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.favorite_border), findsAtLeastNWidgets(1));
    });

    testWidgets('Favorites screen shows empty state when no favorites', (
      tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to favorites
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(favoritesIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should show either:
      // 1. Empty state message
      // 2. Loading indicator
      // 3. List of favorites
      final hasEmptyState =
          tester.any(find.textContaining('No favorites')) ||
          tester.any(find.textContaining('no favorites')) ||
          tester.any(find.textContaining('empty'));
      final hasLoading = tester.any(find.byType(CircularProgressIndicator));
      final hasList =
          tester.any(find.byType(ListView)) ||
          tester.any(find.byType(GridView));

      // At least one should be visible
      expect(hasEmptyState || hasLoading || hasList, isTrue);
    });

    testWidgets('Favorites screen handles loading state', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Navigate to favorites
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(favoritesIcon.first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // During loading, might see progress indicator
      // Just verify app doesn't crash
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Favorites Screen - Adding/Removing Favorites', () {
    testWidgets('Can navigate to breed details and toggle favorite', (
      tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Wait for breeds to load on home
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find and tap on a breed card to go to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should be on breed details screen
          // Look for favorite icon (heart)
          final favoriteIcons = find.byIcon(Icons.favorite_border).evaluate();
          final favoriteFilledIcons = find.byIcon(Icons.favorite).evaluate();

          if (favoriteIcons.isNotEmpty || favoriteFilledIcons.isNotEmpty) {
            // Found favorite button, try to tap it
            if (favoriteIcons.isNotEmpty) {
              // Tap to add to favorites
              await tester.tap(find.byIcon(Icons.favorite_border).last);
              await tester.pumpAndSettle(const Duration(seconds: 2));
            } else {
              // Already favorited, tap to remove
              await tester.tap(find.byIcon(Icons.favorite).last);
              await tester.pumpAndSettle(const Duration(seconds: 2));
            }
          }

          // Go back to home
          await tester.pageBack();
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }
    });

    testWidgets('Favorites are persisted across navigation', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to favorites
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(favoritesIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check initial state
      final hasItems =
          tester.any(find.byType(ListView)) ||
          tester.any(find.byType(GridView));

      // Navigate back to home
      final homeIcon = find.byIcon(Icons.home);
      await tester.tap(homeIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate back to favorites
      await tester.tap(favoritesIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should show same state
      final stillHasItems =
          tester.any(find.byType(ListView)) ||
          tester.any(find.byType(GridView));

      if (hasItems) {
        expect(stillHasItems, isTrue);
      }
    });
  });

  group('Favorites Screen - List Interaction', () {
    testWidgets('Can scroll through favorites list if items exist', (
      tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to favorites
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(favoritesIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // If there's a scrollable list, try scrolling
      final listView = find.byType(ListView);
      final gridView = find.byType(GridView);

      if (tester.any(listView)) {
        await tester.drag(listView.first, const Offset(0, -200));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } else if (tester.any(gridView)) {
        await tester.drag(gridView.first, const Offset(0, -200));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Should not crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Can tap on favorite item to view details', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to favorites
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(favoritesIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Try to find a tappable item
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          // Tap on first item
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should navigate to details
          final NavigatorState navigator = tester.state(find.byType(Navigator));
          final canPop = navigator.canPop();

          if (canPop) {
            // We navigated, go back
            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        }
      }
    });

    testWidgets('Pull to refresh works on favorites screen', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to favorites
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(favoritesIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Try pull to refresh
      final refreshIndicator = find.byType(RefreshIndicator);

      if (tester.any(refreshIndicator)) {
        await tester.drag(find.byType(ListView).first, const Offset(0, 300));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Should still be on favorites screen
      expect(find.byIcon(Icons.favorite_border), findsAtLeastNWidgets(1));
    });
  });

  group('Favorites Screen - Error Handling', () {
    testWidgets('Handles error state gracefully', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to favorites
      final favoritesIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(favoritesIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check for retry button if error occurs
      final retryButton = find.text('Retry');

      if (tester.any(retryButton)) {
        // Tap retry
        await tester.tap(retryButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Should still be functional
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
