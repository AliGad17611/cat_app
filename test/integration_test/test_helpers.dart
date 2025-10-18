import 'package:flutter_test/flutter_test.dart';

/// Helper extension methods for integration tests
extension WidgetTesterExtensions on WidgetTester {
  /// Check if a finder has any matching widgets
  bool any(Finder finder) {
    return finder.evaluate().isNotEmpty;
  }
}
