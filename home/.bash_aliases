# docker
alias dbash='dbash() { docker exec -it $1 /bin/bash ;}; dbash'

# git file transfer ;-)
alias gitarch="git archive HEAD | bzip2 | uuencode /dev/stdout"
alias gitbun="git bundle create - HEAD | uuencode /dev/stdout"

# uue
alias uecp="bzip2 | uuencode /dev/stdout"
alias uedc="uudecode -o - | bunzip2 "
