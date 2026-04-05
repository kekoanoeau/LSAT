#!/usr/bin/env bash
# ─────────────────────────────────────────────
# LSAT Study Hub — iOS Setup Script
# ─────────────────────────────────────────────
set -e

echo "LSAT Study Hub — iOS App Setup"
echo "================================"

# Check for Xcode
if ! xcode-select -p &>/dev/null; then
  echo "ERROR: Xcode not found. Install Xcode from the App Store first."
  exit 1
fi

# Check for XcodeGen, install via Homebrew if missing
if ! command -v xcodegen &>/dev/null; then
  echo "XcodeGen not found. Installing via Homebrew..."
  if ! command -v brew &>/dev/null; then
    echo "ERROR: Homebrew not found. Install from https://brew.sh first."
    exit 1
  fi
  brew install xcodegen
fi

echo "Generating Xcode project..."
cd "$(dirname "$0")"
xcodegen generate

echo ""
echo "✅  Done! Opening project in Xcode..."
open LSATStudyHub.xcodeproj
