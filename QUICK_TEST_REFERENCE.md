# Quick Test Reference Card

## 🎯 Fast Commands

```bash
# Run everything
flutter test

# Quick unit tests
flutter test test/unit/

# Quick widget tests  
flutter test test/widget/

# Specific file
flutter test test/unit/cache_helper_test.dart

# With coverage
flutter test --coverage

# Watch mode
flutter test --watch
```

## 📁 Test Files at a Glance

### Unit Tests (test/unit/)
| File | Tests | What It Tests |
|------|-------|--------------|
| cache_helper_test.dart | 15 | SharedPreferences & SecureStorage |
| api_error_model_test.dart | 31 | API error parsing & handling |
| app_routes_test.dart | 4 | App routing & navigation |

### Widget Tests (test/widget/)
| File | Tests | What It Tests |
|------|-------|--------------|
| primary_button_test.dart | 14 | PrimaryButton widget behavior |
| onboarding_view_test.dart | 13 | Onboarding screen UI & navigation |
| home_view_test.dart | 6 | Home screen UI |
| cat_app_test.dart | 16 | Main app configuration |

## 🛠️ Test Runners

### Windows
```cmd
test_runner.bat all      # All tests
test_runner.bat unit     # Unit only
test_runner.bat widget   # Widget only
test_runner.bat coverage # With coverage
```

### Unix/macOS/Linux
```bash
./test_runner.sh all      # All tests
./test_runner.sh unit     # Unit only
./test_runner.sh widget   # Widget only
./test_runner.sh coverage # With coverage
```

## 📊 Coverage

```bash
# Generate
flutter test --coverage

# View (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
start coverage/html/index.html # Windows
```

## 🔍 Test Structure

```
test/
├── unit/              # Business logic tests
│   ├── cache_helper_test.dart
│   ├── api_error_model_test.dart
│   └── app_routes_test.dart
├── widget/            # UI component tests
│   ├── primary_button_test.dart
│   ├── onboarding_view_test.dart
│   ├── home_view_test.dart
│   └── cat_app_test.dart
├── test_suite.dart    # Run all tests
└── README.md          # Documentation
```

## ✅ Total Test Coverage

- **7 test files**
- **99+ test cases**
- **3 unit test files** (50+ tests)
- **4 widget test files** (49+ tests)

## 📖 Full Documentation

- **test/README.md** - Test directory guide
- **TESTING_GUIDE.md** - Comprehensive guide with examples
- **TEST_SUMMARY.md** - Detailed summary of all tests

## 🎓 Quick Tips

1. **Run tests before committing**
2. **Aim for 75%+ coverage**
3. **Widget overflow warnings are normal in tests**
4. **Use watch mode during development**
5. **Check coverage regularly**

## 🚨 Common Issues

### Overflow Warnings
- **What**: RenderFlex overflow in widget tests
- **Why**: Test viewport (800x600) vs mobile design (375x812)
- **Fix**: Ignore them or wrap content in SingleChildScrollView
- **Impact**: None - tests still work, app is fine

### Asset Errors
- **What**: Can't find assets in tests
- **Why**: Asset paths not configured
- **Fix**: Ensure `pubspec.yaml` includes assets
- **Run**: `flutter pub get`

## 🎯 VS Code Integration

Add to `.vscode/launch.json`:
```json
{
  "name": "Flutter: Run All Tests",
  "type": "dart",
  "request": "launch",
  "program": "test/test_suite.dart"
}
```

## 🔗 Quick Links

- [Flutter Testing Docs](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Unit Testing Guide](https://docs.flutter.dev/cookbook/testing/unit/introduction)

---

**Happy Testing! 🚀**

*For detailed information, see TESTING_GUIDE.md*

