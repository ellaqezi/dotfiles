# bashrc
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
