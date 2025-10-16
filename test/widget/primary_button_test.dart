import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cat_app/core/widgets/primary_button.dart';
import 'package:cat_app/core/utils/app_colors.dart';

void main() {
  group('PrimaryButton Widget Tests', () {
    testWidgets('should display button text', (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(text: 'Test Button', onTap: () {}),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

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

    testWidgets('should display icon when icon is provided', (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(
            text: 'Test Button',
            onTap: () {},
            icon: Icons.pets,
          ),
        ),
      );

      expect(find.byIcon(Icons.pets), findsOneWidget);
    });

    testWidgets('should not display icon when icon is not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(text: 'Test Button', onTap: () {}),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('should display loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(
            text: 'Test Button',
            onTap: () {},
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets(
      'should not display loading indicator when isLoading is false',
      (tester) async {
        await tester.pumpWidget(
          _makeTestableWidget(
            child: PrimaryButton(
              text: 'Test Button',
              onTap: () {},
              isLoading: false,
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Test Button'), findsOneWidget);
      },
    );

    testWidgets('should use custom text color when provided', (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(
            text: 'Test Button',
            onTap: () {},
            textColor: Colors.red,
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test Button'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets(
      'should use default white color when textColor is not provided',
      (tester) async {
        await tester.pumpWidget(
          _makeTestableWidget(
            child: PrimaryButton(text: 'Test Button', onTap: () {}),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('Test Button'));
        expect(textWidget.style?.color, AppColors.white);
      },
    );

    testWidgets('should have full width', (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(text: 'Test Button', onTap: () {}),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(GestureDetector),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.maxWidth, double.infinity);
    });

    testWidgets('should display both icon and text when icon is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(
            text: 'Test Button',
            onTap: () {},
            icon: Icons.pets,
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byIcon(Icons.pets), findsOneWidget);

      // Verify they are in a Row together
      final row = tester.widget<Row>(
        find.descendant(of: find.byType(Center), matching: find.byType(Row)),
      );
      expect(row.children.length, greaterThan(1));
    });

    testWidgets('should have primary color background', (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(text: 'Test Button', onTap: () {}),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(GestureDetector),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.primary);
    });

    testWidgets('should have rounded corners', (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(text: 'Test Button', onTap: () {}),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(GestureDetector),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets('should have shadow', (tester) async {
      await tester.pumpWidget(
        _makeTestableWidget(
          child: PrimaryButton(text: 'Test Button', onTap: () {}),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(GestureDetector),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow?.isNotEmpty, true);
    });
  });
}

// Helper function to wrap widget with MaterialApp and ScreenUtilInit
Widget _makeTestableWidget({required Widget child}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) {
      return MaterialApp(home: Scaffold(body: child));
    },
  );
}
