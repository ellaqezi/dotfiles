# dotfiles
> Setup is done with ansible 🤖 

![zsh][zsh.png]

1. Clone the repo into `~/Documents/projects/`
	```
	  git clone git://repo/to/ellaqezi/dotfiles.git ~/Documents/projects/dotfiles
	```

1. [OPTIONAL] Install `pip` if not yet installed on the machine
	```
    sudo easy_install pip
	```

1. Install ansible
	```
    sudo pip install ansible
	```

1. Run the playbook to setup dotfiles, provide `become` i.e. SUDO password
	```
    ansible-playbook setup-dotfiles.yml --ask-become-pass
    ansible-playbook -i ansible/hosts setup-dotfiles.yml --ask-become-pass (when ansible/hosts is not yet symlinked into place)
	```
    > Note: `become` i.e. SUDO password is required to ensure `docker-py` is installed


## ToDos
- [ ] separate OS-dependent from OS-agnostic tasks in [setup playbook]

## References
1. [Ansible installation]
1. [Homebrew]
1. [Oh my zsh]
1. [Powerline fonts]
1. [Spaceship prompt]
1. [Ansible | tips n tricks]

[Ansible installation]: http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-pip
[Ansible | tips n tricks]: https://ansible-tips-and-tricks.readthedocs.io/en/latest/os-dependent-tasks/variables/
[Homebrew]: https://brew.sh/
[Oh my zsh]: https://github.com/robbyrussell/oh-my-zsh
[Powerline fonts]: https://github.com/powerline/fonts
[setup playbook]: ./setup-dotfiles.yml
[Spaceship prompt]: https://github.com/denysdovhan/spaceship-prompt
[zsh.png]: ./docs/zsh.png
