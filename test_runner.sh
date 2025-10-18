#!/bin/bash

# Cat App Test Runner Script
# This script provides convenient commands to run tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Cat App Test Runner${NC}"
echo "====================="
echo ""

# Function to run all tests
run_all_tests() {
    echo -e "${YELLOW}Running all tests...${NC}"
    flutter test
    echo -e "${GREEN}✓ All tests completed${NC}"
}

# Function to run unit tests only
run_unit_tests() {
    echo -e "${YELLOW}Running unit tests...${NC}"
    flutter test test/unit/
    echo -e "${GREEN}✓ Unit tests completed${NC}"
}

# Function to run widget tests only
run_widget_tests() {
    echo -e "${YELLOW}Running widget tests...${NC}"
    flutter test test/widget/
    echo -e "${GREEN}✓ Widget tests completed${NC}"
}

# Function to run tests with coverage
run_coverage() {
    echo -e "${YELLOW}Running tests with coverage...${NC}"
    flutter test --coverage
    echo -e "${GREEN}✓ Coverage report generated in coverage/lcov.info${NC}"
}

# Function to generate HTML coverage report
generate_coverage_html() {
    echo -e "${YELLOW}Generating HTML coverage report...${NC}"
    
    if ! command -v genhtml &> /dev/null; then
        echo -e "${RED}Error: genhtml not found. Please install lcov:${NC}"
        echo "  macOS: brew install lcov"
        echo "  Ubuntu/Debian: sudo apt-get install lcov"
        echo "  Windows: Use WSL or install lcov manually"
        exit 1
    fi
    
    flutter test --coverage
    genhtml coverage/lcov.info -o coverage/html
    echo -e "${GREEN}✓ HTML coverage report generated in coverage/html/index.html${NC}"
}

# Function to clean test artifacts
clean() {
    echo -e "${YELLOW}Cleaning test artifacts...${NC}"
    rm -rf coverage/
    flutter clean
    flutter pub get
    echo -e "${GREEN}✓ Clean completed${NC}"
}

# Main menu
case "${1}" in
    all)
        run_all_tests
        ;;
    unit)
        run_unit_tests
        ;;
    widget)
        run_widget_tests
        ;;
    coverage)
        run_coverage
        ;;
    html)
        generate_coverage_html
        ;;
    clean)
        clean
        ;;
    watch)
        echo -e "${YELLOW}Running tests in watch mode...${NC}"
        flutter test --watch
        ;;
    *)
        echo "Usage: $0 {all|unit|widget|coverage|html|clean|watch}"
        echo ""
        echo "Commands:"
        echo "  all      - Run all tests"
        echo "  unit     - Run only unit tests"
        echo "  widget   - Run only widget tests"
        echo "  coverage - Run tests with coverage"
        echo "  html     - Generate HTML coverage report"
        echo "  clean    - Clean test artifacts"
        echo "  watch    - Run tests in watch mode"
        echo ""
        echo "Example: $0 all"
        exit 1
        ;;
esac

exit 0

