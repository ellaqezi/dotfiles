#
# Ansible
#
# Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks
# such as continuous deployments or zero downtime rolling updates.
# Link: http://docs.ansible.com/ansible/latest/index.html

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_ANSIBLE_SHOW="${SPACESHIP_ANSIBLE_SHOW=true}"
SPACESHIP_ANSIBLE_PREFIX="${SPACESHIP_ANSIBLE_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_ANSIBLE_SUFFIX="${SPACESHIP_ANSIBLE_SUFFIX=" "}"
SPACESHIP_ANSIBLE_SYMBOL="${SPACESHIP_ANSIBLE_SYMBOL="🅐"}"
SPACESHIP_ANSIBLE_COLOR="${SPACESHIP_ANSIBLE_COLOR="white"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show ansible status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_ansible() {
  # If SPACESHIP_ANSIBLE_SHOW is false, don't show ansible section
  [[ $SPACESHIP_ANSIBLE_SHOW == false ]] && return

  # Show ansible section only when there are ansible-specific files in current
  # working directory.
  # Here glob qualifiers are used to check if files with specific extension are
  # present in directory. Read more about them here:
  # http://zsh.sourceforge.net/Doc/Release/Expansion.html
  [[ -f ansible.cfg || -f .ansible.cfg || -n *.yml(#qN^/) ]] || return

  # Check if ansible command is available for execution
  spaceship::exists ansible || return

  # Retrieve ansible status and save it to variable
  local ansible_status=$(ansible --version 2>&1 | head -n 1 | tr -d ansible)

  # Display ansible section
  spaceship::section \
    "$SPACESHIP_ANSIBLE_COLOR" \
    "$SPACESHIP_ANSIBLE_PREFIX" \
    "$SPACESHIP_ANSIBLE_SYMBOL$ansible_status" \
    "$SPACESHIP_ANSIBLE_SUFFIX"
}
