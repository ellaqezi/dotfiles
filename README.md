# dotfiles
Setup via ansible 🤖 Requires `2.15.5+` and tested on macOS `Ventura 13.6`

![zsh][zsh.png]

## ⚠️ Critical Issues (Refactoring in Progress)

This playbook has known safety issues:

- `.gitconfig` is **symlinked** — replaces existing git config with no backup on work machines
- `.zshrc` is **symlinked** with no escape hatch — local customisations are awkward
- `.oh-my-zsh` is **symlinked** — updates modify the repository, not a local install
- No **backup** of existing dotfiles before overwriting

**Status**: Refactoring is underway following a TDD strategy. See [tests/README.md](tests/README.md) for the test-driven redesign plan.

**For now**: Test this carefully in a VM or isolated user account before running on your main machine.

## Testing the Refactoring

To run the test suite during refactoring:

```bash
# Layer 2: Molecule tests (requires Docker)
pip install molecule ansible-core molecule-docker
molecule test
```

For details, see [tests/README.md](tests/README.md).

## Installation
1. Clone this repo and run `make all` from inside the `dotfiles` directory
	```
    git clone git@github.com:ellaqezi/dotfiles.git
    # remember to set NAME and EMAIL below
    make -C dotfiles all [NAME=<github-user> EMAIL=<github-email>]
	```
 
    > The Makefile instructs you on what it requires e.g. `NAME`, `EMAIL`, `Password` (refers to your SUDO password)


### Step-by-step 	
1. Edit the `templates/.gitconfig` file with your own `user.name` and `user.email`, and move it to `home/.gitconfig`

    ```
    [user]
    	name = ellaqezi 
    	email = ellaqezi@gmail.com
    ```

1. [OPTIONAL] Install `pip`, if not yet installed on the machine
	```
    sudo easy_install pip
	```

1. [OPTIONAL] Install `ansible`, if not yet installed on the machine
	```
    sudo pip install ansible
    
    # [Ubuntu]
    sudo pip install --prefix /usr/local ansible
	```

1. Run the playbook to setup dotfiles, provide `become` i.e. SUDO password
	```
    cd ansible/
    ansible-playbook setup-dotfiles.yml --ask-become-pass
    
    # ... OR when ansible/hosts is not yet symlinked into place
    ansible-playbook -i hosts setup-dotfiles.yml --ask-become-pass 
	```
    > Note: `become` i.e. SUDO password is required to ensure `docker-py` is installed

## References
1. [Ansible | installation]
1. [Ansible | tips n tricks]
1. [Homebrew]
1. [Oh my zsh]
1. [Powerline fonts]
1. [Spaceship prompt]
1. [`ansible/ansible#51513`](https://github.com/ansible/ansible/issues/51513#issuecomment-459150769)
1. [`ansible/ansible#54347`](https://github.com/ansible/ansible/pull/54347)

[Ansible | installation]: http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-pip
[Ansible | tips n tricks]: https://ansible-tips-and-tricks.readthedocs.io/en/latest/os-dependent-tasks/variables/
[Homebrew]: https://brew.sh/
[Oh my zsh]: https://github.com/robbyrussell/oh-my-zsh
[Powerline fonts]: https://github.com/powerline/fonts
[setup playbook]: ./ansible/setup-dotfiles.yml
[Spaceship prompt]: https://github.com/denysdovhan/spaceship-prompt
[filetree]: https://docs.ansible.com/ansible/devel/plugins/lookup/filetree.html
[zsh.png]: docs/zsh.png
