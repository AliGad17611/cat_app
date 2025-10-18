import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cat_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:cat_app/core/utils/app_strings.dart';
import 'package:cat_app/core/routes/routes.dart';
import 'package:cat_app/core/widgets/primary_button.dart';

void main() {
  group('OnboardingView Widget Tests', () {

    testWidgets('should display onboarding title', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.text(AppStrings.onboardingTitle), findsOneWidget);
    });

    testWidgets('should display onboarding description', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.text(AppStrings.onboardingDescription), findsOneWidget);
    });

    testWidgets('should display onboarding image', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display Get Started button', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('should display pets icon on button', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.byIcon(Icons.pets), findsOneWidget);
    });

    testWidgets('should have Scaffold', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have Column as main layout', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      final scaffold = find.byType(Scaffold);
      final column = find.descendant(
        of: scaffold,
        matching: find.byType(Column),
      );

      expect(column, findsOneWidget);
    });

    testWidgets('should navigate to home when Get Started is tapped', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      String? navigatedRoute;

      await tester.pumpWidget(
        _makeTestableWidgetWithNavigationObserver(
          onNavigate: (route) {
            navigatedRoute = route;
          },
        ),
      );

      // Find and tap the Get Started button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(navigatedRoute, Routes.home);
    });

    testWidgets('should center content vertically', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Column),
        ),
      );

      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should have three SizedBox widgets for spacing', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      final sizedBoxes = find.descendant(
        of: find.byType(Column),
        matching: find.byType(SizedBox),
      );

      expect(sizedBoxes, findsAtLeastNWidgets(3));
    });

    testWidgets('title should have center text alignment', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      final titleText = tester.widget<Text>(
        find.text(AppStrings.onboardingTitle),
      );

      expect(titleText.textAlign, TextAlign.center);
    });

    testWidgets('description should have center text alignment', (
      tester,
    ) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      final descriptionText = tester.widget<Text>(
        find.text(AppStrings.onboardingDescription),
      );

      expect(descriptionText.textAlign, TextAlign.center);
    });

    testWidgets('should render all widgets in correct order', (tester) async {
      _setTestViewportSize(tester);
      await tester.pumpWidget(_makeTestableWidget());

      // Verify that widgets appear in the expected order
      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Column),
        ),
      );

      // Image should be first
      expect(column.children[0], isA<Image>());

      // Then spacing
      expect(column.children[1], isA<SizedBox>());

      // Then title
      expect(column.children[2], isA<Text>());

      // Then spacing
      expect(column.children[3], isA<SizedBox>());

      // Then description
      expect(column.children[4], isA<Text>());

      // Then spacing
      expect(column.children[5], isA<SizedBox>());

      // Then button
      expect(column.children[6], isA<PrimaryButton>());
    });
  });
}

// Helper function to set test viewport size
void _setTestViewportSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
}

// Helper function to wrap widget with MaterialApp and ScreenUtilInit
Widget _makeTestableWidget() {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) {
      return const MaterialApp(home: OnboardingView());
    },
  );
}

// Helper function with navigation observer
Widget _makeTestableWidgetWithNavigationObserver({
  required Function(String) onNavigate,
}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) {
      return MaterialApp(
        home: const OnboardingView(),
        navigatorObservers: [_TestNavigatorObserver(onNavigate: onNavigate)],
        routes: {
          Routes.home: (context) =>
              const Scaffold(body: Center(child: Text('Home'))),
        },
      );
    },
  );
}

// Custom NavigatorObserver for testing navigation
class _TestNavigatorObserver extends NavigatorObserver {
  final Function(String) onNavigate;

  _TestNavigatorObserver({required this.onNavigate});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      onNavigate(route.settings.name!);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute?.settings.name != null) {
      onNavigate(newRoute!.settings.name!);
    }
  }
}
