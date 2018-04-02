# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# enable emacs (readline) style on zsh
bindkey -e
# readline-like edit of command line:
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP # don't kill bg processes when exiting
setopt NO_LIST_BEEP # no Beep on an ambiguous completion
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps

setopt PROMPT_SUBST
setopt CORRECT # try to correct the spelling of commands
setopt COMPLETE_IN_WORD

setopt HIST_VERIFY # if the user enters a line with history expansion: 1st expand 2nd execute
setopt EXTENDED_HISTORY # add timestamps to history
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share history across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record duplicates in history
setopt HIST_REDUCE_BLANKS   # remove superflous blanks from each line added to history

# don't remove spaces before an and or a pipe symbol
ZLE_SPACE_SUFFIX_CHARS=$'&|'
