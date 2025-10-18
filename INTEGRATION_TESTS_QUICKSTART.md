# Integration Tests - Quick Start Guide

## 🚀 Quick Start

### Prerequisites
- ✅ Flutter SDK installed
- ✅ Device connected or emulator running
- ✅ Dependencies installed (`flutter pub get`)

### Run All Tests (Recommended)

**Windows:**
```bash
run_integration_tests.bat
```

**macOS/Linux:**
```bash
chmod +x run_integration_tests.sh
./run_integration_tests.sh
```

**Or use Flutter command:**
```bash
flutter test integration_test
```

### Run Single Test File

```bash
flutter test integration_test/app_test.dart
flutter test integration_test/onboarding_integration_test.dart
flutter test integration_test/home_integration_test.dart
flutter test integration_test/favorites_integration_test.dart
flutter test integration_test/breed_details_integration_test.dart
```

## 📝 Test Files Overview

| File | What It Tests | Test Count |
|------|--------------|------------|
| `app_test.dart` | App launch, navigation between tabs | 4 tests |
| `onboarding_integration_test.dart` | Onboarding screen and flow | 5 tests |
| `home_integration_test.dart` | Home screen, breeds list, search, pagination | 11 tests |
| `favorites_integration_test.dart` | Favorites feature, add/remove, persistence | 10 tests |
| `breed_details_integration_test.dart` | Breed details, info display, favorite toggle | 12 tests |

**Total: 42+ integration tests**

## ⚡ Common Commands

### Run with Device Selection
```bash
# List devices
flutter devices

# Run on specific device
flutter test integration_test --device-id=<device_id>
```

### Run with Driver (Real Device Testing)
```bash
flutter drive \
  --driver=integration_test_driver.dart \
  --target=integration_test/app_test.dart
```

### Run with Verbose Output
```bash
flutter test integration_test --verbose
```

## 🐛 Troubleshooting

**Tests timeout?**
- Increase wait times in test code
- Ensure device/emulator is not overloaded

**Widget not found?**
- Wait longer for UI to settle: `pumpAndSettle(Duration(seconds: 5))`
- Check if onboarding was properly skipped

**App doesn't launch?**
- Run `flutter pub get`
- Clean and rebuild: `flutter clean && flutter pub get`
- Restart emulator/device

## 📚 Documentation

- **Detailed Guide**: See `integration_test/README.md`
- **Implementation Summary**: See `INTEGRATION_TESTS_SUMMARY.md`
- **Unit/Widget Tests**: See `test/README.md`

## ✅ What's Covered

✅ Complete user flow from onboarding to main features  
✅ Navigation between all screens  
✅ Adding and removing favorites  
✅ Viewing breed details  
✅ Pull-to-refresh functionality  
✅ Pagination/infinite scroll  
✅ Error states and recovery  
✅ Empty states  
✅ State persistence  

## 🎯 Quick Test Verification

Run this command to verify all tests pass:

```bash
flutter test integration_test
```

Expected output:
```
✓ All tests passed! 42+ tests, 0 failures
```

## 🔄 Continuous Integration

For CI/CD pipelines (GitHub Actions, etc.):

```yaml
- name: Run Integration Tests
  run: flutter test integration_test
```

## 💡 Tips

1. **Run before committing** - Catch integration issues early
2. **Keep tests fast** - Optimize wait times
3. **Update tests with features** - Keep tests in sync with code
4. **Check on real devices** - Not just emulators

---

**Need help?** Check the detailed README: `integration_test/README.md`

