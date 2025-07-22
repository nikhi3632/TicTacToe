#!/bin/bash
set -uo pipefail

# Configuration
SCHEME="TicTacToe"
DESTINATION="platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5"
RESULT_BUNDLE="./TestResults/TicTacToeResults.xcresult"
DERIVED_DATA="./Build/TicTacToeDerivedData"
SUMMARY_JSON="./TestResults/test-summary.json"
COVERAGE_JSON="./TestResults/coverage.json"
TEST_LOG="./TestResults/test-output-triage.log"

# Parse command line arguments
ARCHITECTURE=""
VERBOSE=false
PRESERVE_RESULTS=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --arch)
      ARCHITECTURE="$2"
      shift 2
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --preserve-results)
      PRESERVE_RESULTS=true
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --arch <arm64|x86_64>     Specify architecture (default: both)"
      echo "  --verbose                 Enable verbose output"
      echo "  --preserve-results        Don't clean previous results"
      echo "  --help                    Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Update destination with architecture if specified
if [[ -n "$ARCHITECTURE" ]]; then
  DESTINATION="platform=iOS Simulator,arch=$ARCHITECTURE,name=iPhone 16 Pro,OS=18.5"
  RESULT_BUNDLE="./TestResults/TicTacToeResults_${ARCHITECTURE}.xcresult"
  SUMMARY_JSON="./TestResults/test-summary_${ARCHITECTURE}.json"
  COVERAGE_JSON="./TestResults/coverage_${ARCHITECTURE}.json"
  TEST_LOG="./TestResults/test-output-triage_${ARCHITECTURE}.log"
fi

# Clean or preserve previous results
if [[ "$PRESERVE_RESULTS" == false ]]; then
  echo "🧹 Cleaning previous results..."
  rm -rf ./TestResults ./Build
else
  echo "🔄 Preserving previous results..."
fi

echo "📁 Creating directories..."
mkdir -p "$(dirname "$RESULT_BUNDLE")" "$DERIVED_DATA" ./TestResults

echo "🧪 Running tests for scheme: $SCHEME"
echo "📱 Destination: $DESTINATION"
echo "📊 Architecture: ${ARCHITECTURE:-"default (both arm64 & x86_64)"}"

# Build xcodebuild command
XCODEBUILD_CMD=(
  xcodebuild test
  -scheme "$SCHEME"
  -destination "$DESTINATION"
  -enableCodeCoverage YES
  -resultBundlePath "$RESULT_BUNDLE"
  -derivedDataPath "$DERIVED_DATA"
  -parallel-testing-enabled NO
)

# Add verbose flag if requested
if [[ "$VERBOSE" == true ]]; then
  XCODEBUILD_CMD+=(-verbose)
fi

# Run tests
echo ""
if [[ "$VERBOSE" == true ]]; then
  "${XCODEBUILD_CMD[@]}" 2>&1 | tee "$TEST_LOG" | xcbeautify --preserve-unbeautified
else
  "${XCODEBUILD_CMD[@]}" 2>&1 | tee "$TEST_LOG" | xcbeautify
fi

# Determine if tests failed
TEST_FAILED=false
if [[ -f "$TEST_LOG" ]] && grep -q "Test Failed" "$TEST_LOG"; then
  TEST_FAILED=true
fi

# Parse test results
echo ""
echo "📂 Parsing test results..."
if ! XCRESULT_ID=$(xcrun xcresulttool get --path "$RESULT_BUNDLE" --format json --legacy 2>/dev/null | jq -r '.actions._values[0].actionResult.testsRef.id._value' 2>/dev/null); then
  echo "⚠️  Warning: Could not extract test summary ID"
  XCRESULT_ID=""
fi

if [[ -n "$XCRESULT_ID" && "$XCRESULT_ID" != "null" ]]; then
  if xcrun xcresulttool get --path "$RESULT_BUNDLE" --id "$XCRESULT_ID" --format json --legacy > "$SUMMARY_JSON" 2>/dev/null; then
    echo "✅ Test summary saved to: $SUMMARY_JSON"
  else
    echo "⚠️  Warning: Could not generate test summary JSON"
  fi
else
  echo "⚠️  Warning: Skipping test summary extraction"
fi

# Generate code coverage
echo ""
echo "📈 Code Coverage:"
echo "================="
if xcrun xccov view --report --json "$RESULT_BUNDLE" > "$COVERAGE_JSON" 2>/dev/null; then
  echo "✅ Coverage JSON saved to: $COVERAGE_JSON"
  echo ""
  xcrun xccov view --report "$RESULT_BUNDLE" 2>/dev/null || echo "⚠️  Could not display coverage report"
else
  echo "⚠️  Warning: Could not generate coverage report"
fi

echo ""
echo "📂 Grouped Test Results:"
echo "================"

jq -r '
  .. | objects | select(has("testStatus")) |
  {
    name: (.identifier._value // .name._value),
    status: .testStatus._value
  }
' ./TestResults/test-summary.json | jq -s '
  group_by(.status) |
  map({
    (.[0].status): (
      group_by(.name) | map({ 
        name: .[0].name, 
        count: length 
      })
    )
  }) | add
'

echo "📊 Test Summary:"
echo "================"

jq -r '
  .. | objects | select(has("testStatus")) |
  # No filtering of testLaunch or Performance here
  .testStatus._value
' ./TestResults/test-summary.json | sort | uniq -c | awk '
  BEGIN { total=0; success=0; failure=0 }
  /Success/ { success=$1; total+=success }
  /Failure/ { failure=$1; total+=failure }
  END {
    print "Total tests:", total
    print "✅ Passed:", success
    print "❌ Failed:", failure
  }
'

# Final output paths
echo ""
echo "📂 Generated Files:"
echo "=================="
echo "📊 Result bundle: $RESULT_BUNDLE"
echo "📄 Test log: $TEST_LOG"
[[ -f "$SUMMARY_JSON" ]] && echo "📄 Summary JSON: $SUMMARY_JSON"
[[ -f "$COVERAGE_JSON" ]] && echo "📄 Coverage JSON: $COVERAGE_JSON"

echo ""
if [[ "$TEST_FAILED" == true ]]; then
  echo "❌ Some tests failed. Check the logs above."
  exit 1
else
  echo "🎉 Test run completed successfully!"
  exit 0
fi
