#!/usr/bin/env bash
# Layer 3: End-to-end integration tests
# Run AFTER the Ansible playbook completes to verify the install is safe.
# Tests that identity/personalization files work correctly post-install.

set -euo pipefail

echo "=== Layer 3: Post-Install Identity Verification ==="

# Test 1: .gitconfig is a regular file, not a symlink
echo "✓ Test 1: ~/.gitconfig is a regular file (not symlink)"
if [[ -L "$HOME/.gitconfig" ]]; then
  echo "  FAIL: ~/.gitconfig is a symlink (Step 2 refactoring not applied)"
  exit 1
fi
if [[ ! -f "$HOME/.gitconfig" ]]; then
  echo "  FAIL: ~/.gitconfig does not exist"
  exit 1
fi
echo "  PASS: ~/.gitconfig is a regular file"

# Test 2: .zshrc sources .zshrc.local if present
echo "✓ Test 2: ~/.zshrc sources ~/.zshrc.local escape hatch"
if ! grep -q '\.zshrc\.local' "$HOME/.zshrc"; then
  echo "  FAIL: ~/.zshrc does not source ~/.zshrc.local (Step 3 refactoring not applied)"
  exit 1
fi

# Create a test .zshrc.local and verify it's sourced
test_var_value="dotfiles-integration-test-$(date +%s)"
cat > "$HOME/.zshrc.local" <<EOF
export DOTFILES_TEST_VAR="$test_var_value"
EOF

# Source the shell config and check the test var
if bash -i -c "source $HOME/.zshrc; echo \$DOTFILES_TEST_VAR" 2>/dev/null | grep -q "$test_var_value"; then
  echo "  PASS: ~/.zshrc.local is sourced correctly"
else
  echo "  FAIL: ~/.zshrc.local was not sourced"
  rm "$HOME/.zshrc.local"
  exit 1
fi

rm "$HOME/.zshrc.local"

# Test 3: ~/.oh-my-zsh is a directory, not a symlink
echo "✓ Test 3: ~/.oh-my-zsh is a directory (not symlink)"
if [[ -L "$HOME/.oh-my-zsh" ]]; then
  echo "  FAIL: ~/.oh-my-zsh is a symlink (Step 4 refactoring not applied)"
  exit 1
fi
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "  FAIL: ~/.oh-my-zsh is not a directory"
  exit 1
fi
echo "  PASS: ~/.oh-my-zsh is a real directory"

# Test 4: .bashrc is a symlink (safe to symlink)
echo "✓ Test 4: ~/.bashrc is a symlink (correctly managed by ansible)"
if [[ ! -L "$HOME/.bashrc" ]]; then
  echo "  WARN: ~/.bashrc is not a symlink (expected to be symlinked from repo)"
else
  echo "  PASS: ~/.bashrc is correctly symlinked"
fi

# Test 5: home/.gitconfig is in .gitignore (no accidental commits of identity)
echo "✓ Test 5: Generated .gitconfig not tracked in git"
repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
if grep -q "home/.gitconfig" "$repo_root/.gitignore" 2>/dev/null; then
  echo "  PASS: home/.gitconfig is in .gitignore"
else
  echo "  WARN: home/.gitconfig not in .gitignore (will pass after Step 7 refactoring)"
fi

echo ""
echo "=== Layer 3: All post-install identity tests completed ==="
