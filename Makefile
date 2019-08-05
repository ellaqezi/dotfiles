# dotfiles Makefile
.ONESHELL:
SHELL:=/bin/bash

validate:
	@[[ -z $$NAME ]]  && echo 'export  NAME=<user>' &&  exit 1 || echo   NAME=$(NAME)
	@[[ -z $$EMAIL ]] && echo 'export EMAIL=<email>' && exit 1 || echo  EMAIL=$(EMAIL)

gitconfig: validate
	@cat templates/gitconfig | sed -e 's/NAME/"$(NAME)"/g' -e 's/EMAIL/"$(EMAIL)"/g' > home/.gitconfig

install-tools:
	@sudo easy_install pip
	@sudo pip install ansible

all: gitconfig install-tools
	@ansible-playbook -i ansible/hosts ansible/setup-dotfiles.yml --ask-become-pass