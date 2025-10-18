#!/bin/bash

# Integration Test Runner for macOS/Linux
# Run all integration tests or specific test files

echo "========================================"
echo "Cat App Integration Test Runner"
echo "========================================"
echo ""

# Check if a specific test file is provided
if [ -z "$1" ]; then
    echo "Running all integration tests..."
    echo ""
    
    echo "Running app_test.dart..."
    flutter test integration_test/app_test.dart
    
    echo ""
    echo "Running onboarding_integration_test.dart..."
    flutter test integration_test/onboarding_integration_test.dart
    
    echo ""
    echo "Running home_integration_test.dart..."
    flutter test integration_test/home_integration_test.dart
    
    echo ""
    echo "Running favorites_integration_test.dart..."
    flutter test integration_test/favorites_integration_test.dart
    
    echo ""
    echo "Running breed_details_integration_test.dart..."
    flutter test integration_test/breed_details_integration_test.dart
    
else
    echo "Running specific test: $1"
    echo ""
    flutter test "integration_test/$1"
fi

echo ""
echo "========================================"
echo "Integration tests completed!"
echo "========================================"

