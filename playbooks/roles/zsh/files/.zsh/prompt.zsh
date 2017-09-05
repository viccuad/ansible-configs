# load ZSH colors, easier than bash ones
autoload colors && colors

# GIT prompt:
# at /usr/lib/git-core/git-sh-prompt
export GIT_PS1_SHOWDIRTYSTATE="true"
export GIT_PS1_SHOWSTASHSTATE="true"
export GIT_PS1_SHOWUNTRACKEDFILES="true"
export GIT_PS1_SHOWUPSTREAM="auto verbose"
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWCOLORHINTS="true" # only available when using precmd()
export GIT_PS1_HIDE_IF_PWD_IGNORED="true"

# TODO make the prompt oh my zsh compatible

# PROMPT build:
prompt_pwd() {
    echo "%{$fg_bold[white]%}%~%{$reset_color%}"
}

prompt_names() {
    echo "%{$fg_bold[yellow]%}%n@%M%{$reset_color%}"
}

prompt_symbol() {
    echo "%{$fg_bold[white]%}$%{$reset_color%}"
}
prompt_last_status() {
    echo "%(?..%{$fg_bold[red]%} %?% %{$reset_color%})"
}

rprompt_time() {
    echo "%{$fg[white]%}%T%{$reset_color%}"
}


precmd() {
    # set_prompt
    # __git_ps1 usage: __git_ps1 pre_git_prompt post_git_prompt
    __git_ps1 "$(prompt_names)$(prompt_last_status) $(prompt_pwd)" "$(prompt_symbol) "
    # RPROMPT="$(rprompt_todo) $(rprompt_time)"
    # RPROMPT="$(rprompt_time)"
}
