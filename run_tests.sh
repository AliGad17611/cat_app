#!/bin/bash

# Cat App Test Runner Script
# This script generates mocks and runs all tests

echo "=========================================="
echo "Cat App Test Runner"
echo "=========================================="
echo ""

# Step 1: Generate mocks
echo "Step 1: Generating mock files..."
echo "Running: dart run build_runner build --delete-conflicting-outputs"
dart run build_runner build --delete-conflicting-outputs

if [ $? -eq 0 ]; then
    echo "✅ Mock files generated successfully"
else
    echo "❌ Failed to generate mock files"
    exit 1
fi

echo ""

# Step 2: Run all tests
echo "Step 2: Running all tests..."
echo "Running: flutter test"
flutter test

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All tests passed!"
else
    echo ""
    echo "❌ Some tests failed"
    exit 1
fi

echo ""
echo "=========================================="
echo "Test run completed successfully!"
echo "=========================================="

