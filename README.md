# dotfiles

Setup is done with ansible.

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

1. Run the playbook to setup dotfiles, provide `become` (sudo) password
	```
	ansible-playbook setup-dotfiles.yml --ask-become-pass
	ansible-playbook -i ansible/hosts setup-dotfiles.yml --ask-become-pass (when ansible/hosts is not yet symlinked into place)
	```

## References
1. [Ansible installation](http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-pip)
1. [Homebrew}(https://brew.sh/)
1. [Oh my zsh](https://github.com/robbyrussell/oh-my-zsh)
1. [Powerline fonts](https://github.com/powerline/fonts)
1. [Spaceship prompt](https://github.com/denysdovhan/spaceship-prompt)

