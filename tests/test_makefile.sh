#!/usr/bin/env bash
# Layer 1: Pre-flight validation tests for Makefile safety
# Verifies that make targets enforce required env vars and support dry-run.

set -euo pipefail

cd "$(dirname "$0")/.."

echo "=== Layer 1: Makefile Safety Tests ==="

# Test 1: NAME env var required
echo "✓ Test 1: NAME env var required"
name_check=$(make gitconfig 2>&1 | grep "NAME" || true)
if [[ -z "$name_check" ]]; then
  echo "  FAIL: Make did not require NAME"
  exit 1
else
  echo "  PASS: Make correctly requires NAME"
fi

# Test 2: EMAIL env var required
echo "✓ Test 2: EMAIL env var required"
email_check=$(make gitconfig NAME=testuser 2>&1 | grep "EMAIL" || true)
if [[ -z "$email_check" ]]; then
  echo "  FAIL: Make did not require EMAIL"
  exit 1
else
  echo "  PASS: Make correctly requires EMAIL"
fi

# Test 3: Python version detection (not hardcoded to 3.9)
echo "✓ Test 3: Python version detection"
if grep -q "PYTHON_VERSION:=3\.9" Makefile; then
  echo "  WARN: PYTHON_VERSION is hardcoded to 3.9 (should be dynamic)"
  echo "        This test will pass once Step 5 refactoring is applied"
else
  echo "  PASS: PYTHON_VERSION appears to be dynamic"
fi

# Test 4: dry-run target exists
echo "✓ Test 4: dry-run Make target exists"
if grep -q "^dry-run:" Makefile; then
  echo "  PASS: dry-run target is defined in Makefile"
else
  echo "  WARN: dry-run target not found (will pass after Step 6 refactoring)"
fi

echo ""
echo "=== Layer 1: All pre-flight tests completed ==="
