# dotfiles
Setup via ansible `2.5.0`  🤖

![zsh][zsh.png]

1. Clone the repo into `~/Documents/projects/`
	```
	  git clone git://repo/to/ellaqezi/dotfiles.git ~/Documents/projects/dotfiles
	```
1. Edit the `.gitconfig` file and use your own `user.name` and `user.email`

    ```
    [user]
    	name = ellaqezi 
    	email = ellaqezi@gmail.com
    ```

1. [OPTIONAL] Install `pip` if not yet installed on the machine
	```
    sudo easy_install pip
	```

1. Install ansible
	```
    sudo pip install ansible
    
    [Ubuntu]
    sudo pip install --prefix /usr/local ansible
	```

1. Run the playbook to setup dotfiles, provide `become` i.e. SUDO password
	```
    cd ansible/
    ansible-playbook setup-dotfiles.yml --ask-become-pass
    ... OR when ansible/hosts is not yet symlinked into place
    ansible-playbook -i hosts setup-dotfiles.yml --ask-become-pass 
	```
    > Note: `become` i.e. SUDO password is required to ensure `docker-py` is installed


## ToDos
- [x] separate OS-dependent from OS-agnostic tasks in [setup playbook]
- [x] workaround [**BUG** filetree]


## Known issues
> <a name="filetree-bug"/>🐛 **BUG** filetree *affects [version 2.4]* ⚠️ <br/>
> throws error: **'dict object' has no attribute 'src'** although the
dictionary starts with `(item={'src':` <br/>
>
> 🦄 **FIX** concatenate `item.root` and `item.path` and use that
instead of `item.src`


## References
1. [Ansible | installation]
1. [Ansible | tips n tricks]
1. [Homebrew]
1. [Oh my zsh]
1. [Powerline fonts]
1. [Spaceship prompt]

[Ansible | installation]: http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-pip
[Ansible | tips n tricks]: https://ansible-tips-and-tricks.readthedocs.io/en/latest/os-dependent-tasks/variables/
[**BUG** filetree]: #filetree-bug
[Homebrew]: https://brew.sh/
[Oh my zsh]: https://github.com/robbyrussell/oh-my-zsh
[Powerline fonts]: https://github.com/powerline/fonts
[setup playbook]: ./setup-dotfiles.yml
[Spaceship prompt]: https://github.com/denysdovhan/spaceship-prompt
[version 2.4]: https://docs.ansible.com/ansible/devel/plugins/lookup/filetree.html
[zsh.png]: ./docs/zsh.png
