#!/bin/bash

set -e

SCHEME="TicTacToe"
DESTINATION="platform=iOS Simulator,name=iPhone 16 Pro"
RESULT_BUNDLE="./TestResults/TicTacToeResults.xcresult"
DERIVED_DATA="./Build/TicTacToeDerivedData"

echo "🧹 Cleaning previous results..."
rm -rf ./TestResults ./Build

echo "📁 Creating directories..."
mkdir -p "$(dirname "$RESULT_BUNDLE")" "$DERIVED_DATA"

echo "🧪 Running tests for scheme: $SCHEME"
xcodebuild test \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -enableCodeCoverage YES \
  -resultBundlePath "$RESULT_BUNDLE" \
  -derivedDataPath "$DERIVED_DATA" \
  -parallel-testing-enabled NO \
  -verbose

echo "✅ Test run complete."
echo "📂 Result bundle: $RESULT_BUNDLE"
echo ""
echo "📈 Code Coverage:"
xcrun xccov view --report "$RESULT_BUNDLE"

echo ""
echo "🧪 Done."
