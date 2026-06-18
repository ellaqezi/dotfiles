# dotfiles Test Suite

Three-layer TDD test strategy for dotfiles refactoring safety.

## Quick Start

```bash
# Layer 1: Makefile safety checks (bash)
bash tests/test_makefile.sh

# Layer 2: Playbook isolation tests (molecule)
pip install molecule ansible-core molecule-docker
molecule test

# Layer 3: Post-install integration (bash, run after real install)
make install && bash tests/test_identity.sh
```

## Test Layers

### Layer 1: Makefile Safety (`tests/test_makefile.sh`)
- Verifies `make gitconfig` requires `NAME` and `EMAIL` env vars
- Checks Python version detection (not hardcoded to 3.9)
- Confirms `dry-run` Make target exists

**Run before refactoring.** No infrastructure required.

```bash
bash tests/test_makefile.sh
```

### Layer 2: Playbook Idempotency (`molecule/`)
- Tests fresh install in isolated Docker container
- Tests re-run idempotency and backup behavior
- Verifies refactoring step assertions (Steps 1–7)

**Requires Molecule and Docker.** Run during refactoring to validate each step.

```bash
# All scenarios
molecule test

# Single scenario
molecule test
molecule test --scenario-name=rerun-idempotent

# Debug mode (keep container, shell into it)
molecule converge
molecule converge --scenario-name=rerun-idempotent
```

**Molecule scenarios:**

| Scenario | Tests | Driven by |
|---|---|---|
| `default` | Fresh install with no existing dotfiles; all Step 2–7 assertions | `verify.yml` |
| `rerun-idempotent` | Re-run with existing dotfiles; backup behavior; idempotency | `converge.yml` |

### Layer 3: Post-Install Identity (`tests/test_identity.sh`)
- Tests `.gitconfig` is a regular file (Step 2)
- Verifies `.zshrc.local` escape hatch works (Step 3)
- Checks `.oh-my-zsh` is a directory, not symlink (Step 4)
- Confirms `home/.gitconfig` is in `.gitignore` (Step 7)

**Run on a real machine after `make install`.** Validates the install is safe.

```bash
# After real installation
bash tests/test_identity.sh
```

## Test Execution Plan

### Before Refactoring (Establish Red Baseline)

```bash
cd tests/audit/dotfiles

# Layer 1: Makefile tests
bash tests/test_makefile.sh
# Expected: Some tests pass (assertions added in Step 5 & 6)

# Layer 2: Molecule tests
molecule test
# Expected: Failures on Steps 2, 3, 4, 7 assertions (current code doesn't implement them)

# Layer 3: Post-install (optional on real machine)
# Skip for now — requires real install
```

### During Refactoring (Apply Steps 1–7)

After implementing each step, re-run the relevant layer:

```bash
# After Step 1 (backup before symlink)
molecule test --scenario-name=rerun-idempotent

# After Step 2 (remove .gitconfig from symlink loop)
molecule test

# After Step 3 (.zshrc.local escape hatch)
molecule test

# ... and so on for Steps 4–7

# After all steps complete
molecule test
bash tests/test_makefile.sh
```

### After Refactoring (Green State)

```bash
bash tests/test_makefile.sh        # All ✓
molecule test                       # All passed (both scenarios)

# On a real machine
make install && bash tests/test_identity.sh  # All ✓
```

## Fixture/Scenario Details

### Initial Install Scenario
- **Setup**: Clean container with no `~/.bashrc`, `~/.zshrc`, etc.
- **Test**: Playbook runs; all dotfiles symlinked correctly
- **Verify**: Steps 2–7 assertions pass

### Re-run Idempotent Scenario
- **Setup**: Container with existing `~/.zshrc` and `~/.bashrc` (to test backup behavior)
- **Converge**: Playbook runs twice (tests idempotency)
- **Verify**: Backups created, original content preserved, playbook is idempotent

## Troubleshooting

### `WARNING: Package(s) not found: molecule-docker`
The `molecule[docker]` syntax is **not valid** — Molecule uses separate plugin packages. Install the docker driver directly:

```bash
# ✓ Correct
pip install molecule ansible-core molecule-docker

# ✗ Wrong (non-existent extra)
pip install 'molecule[docker]' ansible-core
```

If the warning persists after installation, verify:
```bash
pip show molecule-docker    # Should show Name: molecule-docker, Version: ...
python3 -c "import molecule_docker; print('✓ docker driver available')"
```

### Molecule test fails: "Failed to find driver docker"
Docker driver is not installed or Docker daemon is not running. Follow this checklist:

**1. Check if Docker daemon is running:**
```bash
docker ps
```
- If this succeeds, Docker is running ✓
- If it fails ("Cannot connect to Docker daemon"), start Docker:
  - **macOS**: `open /Applications/Docker.app`
  - **Linux**: `sudo systemctl start docker`

**2. Check if Docker is installed:**
```bash
docker --version
```
- If "command not found", install Docker:
  - **macOS**: `brew install --cask docker && open /Applications/Docker.app`
  - **Linux**: `sudo apt update && sudo apt install docker.io && sudo systemctl start docker`

**3. Check if the molecule-docker plugin is installed:**
```bash
pip show molecule-docker
python3 -c "import molecule_docker; print('✓ installed')"
```
- If not found, install it directly (the `molecule[docker]` extra doesn't exist):
  ```bash
  pip install molecule-docker
  ```

**4. Verify Molecule can find the docker driver:**
```bash
python3 -c "from molecule.plugins.driver import docker; print('✓ docker driver found')"
```

Once all four checks pass, `molecule test` should work.

### Molecule test fails: "Ansible not found"
```bash
pip install ansible-core
```

### test_identity.sh fails: "Not running after real install"
The Layer 3 tests are integration tests — they only work after you've actually run `make install` on your machine. They verify the real install is safe.

### Tests expect FAIL but code already implements it
If a refactoring step is already implemented in the code, the corresponding molecule assertion will pass (not fail). This is fine — it means the step is done. Review the code to ensure it matches the intended design.

## Design Principles

1. **TDD First**: Tests written before refactoring begins
2. **Isolation**: Molecule tests run in containers; no risk to your `~`
3. **Clarity**: Each assertion corresponds to one refactoring step
4. **Incremental**: Each step can be implemented and verified independently
5. **Backward Compat**: Tests ensure no silent failures or data loss

## References

- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Ansible Testing Best Practices](https://docs.ansible.com/ansible/latest/reference_appendices/test_strategies.html)
- Refactoring steps: See `README.md` "Redesign steps — ordered by risk"
