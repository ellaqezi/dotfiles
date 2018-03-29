#! /bin/bash
[[ -e '/usr/local/bin/brew' ]] && echo "Brew is installed" \
|| yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 2>&1
brew analytics off
exit 0
