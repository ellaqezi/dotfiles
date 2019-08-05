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
SPACESHIP_ANSIBLE_SHOW_VERSION="${SPACESHIP_ANSIBLE_SHOW_VERSION=false}"
SPACESHIP_ANSIBLE_PREFIX="${SPACESHIP_ANSIBLE_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_ANSIBLE_SUFFIX="${SPACESHIP_ANSIBLE_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_ANSIBLE_SYMBOL="${SPACESHIP_ANSIBLE_SYMBOL="🅐·"}"
SPACESHIP_ANSIBLE_COLOR="${SPACESHIP_ANSIBLE_COLOR="white"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show ansible status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_ansible() {
  # If SPACESHIP_ANSIBLE_SHOW is false, don't show ansible section
  [[ ${SPACESHIP_ANSIBLE_SHOW} == false ]] && return

  # Check if ansible command is available for execution
  spaceship::exists ansible || return

  # Show ansible section only when there are ansible-specific files in current
  # working directory.
  # Here glob qualifiers are used to check if files with specific extension are
  # present in directory. Read more about them here:
  # http://zsh.sourceforge.net/Doc/Release/Expansion.html
  YAML=$(echo *.yml([1]N^/))
  [[ -f ansible.cfg || -f .ansible.cfg || -f $YAML && $(grep -m 1 -E "tasks|hosts" $YAML &> /dev/null) -eq 0 ]] || return
  #[[ -f ansible.cfg || -f .ansible.cfg || -f $YAML && $(ansible-playbook --syntax-check $YAML &> /dev/null) -eq 0 ]] || return

  # Retrieve ansible status and save it to variable
  [[ ${SPACESHIP_ANSIBLE_SHOW_VERSION} = true ]] && ansible_status=`ansible --version 2>&1 | head -n 1 | tr -d ansible`

  # Display ansible section
  spaceship::section \
    "$SPACESHIP_ANSIBLE_COLOR" \
    "$SPACESHIP_ANSIBLE_PREFIX" \
    "$SPACESHIP_ANSIBLE_SYMBOL$ansible_status" \
    "$SPACESHIP_ANSIBLE_SUFFIX"
}
