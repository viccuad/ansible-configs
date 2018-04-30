alias reload!='. ~/.zshrc'

LS_OPTIONS=(-F --color=auto);
alias ls='ls $LS_OPTIONS'
alias ll='ls -lh'
alias la='ls -lah'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias th='trash --verbose'
function xdg () {
    xdg-open "$*" 2>/dev/null &
}

alias fullcharge="sudo tlp fullcharge BAT0; sudo tlp fullcharge BAT1"

