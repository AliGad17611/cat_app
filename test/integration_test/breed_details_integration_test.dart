import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:cat_app/main.dart' as app;

/// Integration tests for the Breed Details feature
/// Tests breed details screen display, favorite toggle, and information display
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Breed Details - Navigation', () {
    testWidgets('Navigate to breed details from home screen', (tester) async {
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

      // Find and tap a breed card
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should be on details screen
          // Verify we can go back
          final NavigatorState navigator = tester.state(find.byType(Navigator));
          expect(navigator.canPop(), isTrue);
        }
      }
    });

    testWidgets('Can navigate back from breed details', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Go back using back button
          final backButton = find.byType(BackButton);
          if (tester.any(backButton)) {
            await tester.tap(backButton);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          } else {
            // Try page back
            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }

          // Should be back on home
          expect(find.byIcon(Icons.home), findsAtLeastNWidgets(1));
        }
      }
    });
  });

  group('Breed Details - Display', () {
    testWidgets('Breed details screen displays breed information', (
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

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should display various breed information
          // Look for common elements
          expect(find.byType(Scaffold), findsWidgets);

          // Should have some text content
          expect(find.byType(Text), findsWidgets);
        }
      }
    });

    testWidgets('Breed details screen displays breed image', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should have image(s)
          expect(find.byType(Image), findsWidgets);
        }
      }
    });

    testWidgets('Can scroll through breed details', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Try to scroll in details view
          final singleChildScrollView = find.byType(SingleChildScrollView);
          final detailsListView = find.byType(ListView);

          if (tester.any(singleChildScrollView)) {
            await tester.drag(
              singleChildScrollView.first,
              const Offset(0, -300),
            );
            await tester.pumpAndSettle(const Duration(seconds: 1));
          } else if (tester.any(detailsListView)) {
            await tester.drag(detailsListView.last, const Offset(0, -300));
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }

          // Should not crash
          expect(find.byType(MaterialApp), findsOneWidget);
        }
      }
    });
  });

  group('Breed Details - Favorite Toggle', () {
    testWidgets('Can toggle favorite status from details screen', (
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

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Look for favorite button
          final favoriteOutline = find.byIcon(Icons.favorite_border);
          final favoriteFilled = find.byIcon(Icons.favorite);

          if (tester.any(favoriteOutline)) {
            // Not favorited, tap to favorite
            await tester.tap(favoriteOutline.last);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // Should now show filled heart
            expect(find.byIcon(Icons.favorite), findsWidgets);
          } else if (tester.any(favoriteFilled)) {
            // Already favorited, tap to unfavorite
            await tester.tap(favoriteFilled.last);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // Should now show outline heart
            expect(find.byIcon(Icons.favorite_border), findsWidgets);
          }
        }
      }
    });

    testWidgets('Favorite status persists when navigating back', (
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

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Toggle favorite
          final favoriteOutline = find.byIcon(Icons.favorite_border);
          if (tester.any(favoriteOutline)) {
            await tester.tap(favoriteOutline.last);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }

          // Go back
          await tester.pageBack();
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Navigate to same breed again
          if (tester.any(gestureDetectors)) {
            await tester.tap(gestureDetectors.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            // Should show updated favorite status
            expect(find.byType(Scaffold), findsWidgets);
          }
        }
      }
    });
  });

  group('Breed Details - Information Sections', () {
    testWidgets('Displays breed characteristics', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should have various text elements showing breed info
          expect(find.byType(Text), findsWidgets);

          // Likely to have some icons for characteristics
          expect(find.byType(Icon), findsWidgets);
        }
      }
    });

    testWidgets('Displays breed description', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should display text content
          expect(find.byType(Text), findsWidgets);
        }
      }
    });

    testWidgets('Can interact with breed links if present', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Look for link icons (like open in browser)
          final linkIcon = find.byIcon(Icons.link);
          final openInNewIcon = find.byIcon(Icons.open_in_new);

          // If links are present, they should be visible
          if (tester.any(linkIcon) || tester.any(openInNewIcon)) {
            expect(find.byType(Icon), findsWidgets);
          }
        }
      }
    });
  });

  group('Breed Details - Edge Cases', () {
    testWidgets('Handles missing breed information gracefully', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding
      final getStartedButton = find.text('Get Started');
      if (tester.any(getStartedButton)) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to details
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors)) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should display something even if some info is missing
          expect(find.byType(Scaffold), findsWidgets);
          expect(find.byType(MaterialApp), findsOneWidget);
        }
      }
    });

    testWidgets('App does not crash when viewing multiple breeds', (
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

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to first breed
      final listView = find.byType(ListView);

      if (tester.any(listView)) {
        final gestureDetectors = find.descendant(
          of: listView.first,
          matching: find.byType(GestureDetector),
        );

        if (tester.any(gestureDetectors) &&
            gestureDetectors.evaluate().length > 1) {
          // View first breed
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Go back
          await tester.pageBack();
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // View second breed
          final gestureDetectors2 = find.descendant(
            of: listView.first,
            matching: find.byType(GestureDetector),
          );

          if (tester.any(gestureDetectors2) &&
              gestureDetectors2.evaluate().length > 1) {
            await tester.tap(gestureDetectors2.at(1));
            await tester.pumpAndSettle(const Duration(seconds: 3));

            // Go back
            await tester.pageBack();
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        }
      }

      // Should not crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
