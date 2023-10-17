# dotfiles Makefile
.ONESHELL:
SHELL:=/bin/zsh

validate:
	@[[ -z $$NAME ]]  && echo 'export  NAME=<user>' &&  exit 1 || echo   NAME=$(NAME)
	@[[ -z $$EMAIL ]] && echo 'export EMAIL=<email>' && exit 1 || echo  EMAIL=$(EMAIL)

gitconfig: validate
	@cat templates/gitconfig | sed -e 's/NAME/"$(NAME)"/g' -e 's/EMAIL/"$(EMAIL)"/g' > home/.gitconfig

install-tools:
	@sudo python3 -m ensurepip || sudo apt install pip
	@echo "export PATH=\"`python3 -m site --user-base`/bin:\$PATH\"" >> ~/.zshrc
	@pip install ansible

all: gitconfig install-tools
	@ansible-playbook -i ansible/hosts ansible/setup-dotfiles.yml --ask-become-pass