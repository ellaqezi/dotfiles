#! /bin/bash
[[ -e '/usr/local/bin/brew' ]] && echo "Brew is installed" \
|| yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>&1
brew analytics off
exit 0
