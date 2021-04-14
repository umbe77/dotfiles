#                        __                  __
#                       / /_   ____ _ _____ / /_   _____ _____
#                      / __ \ / __ `// ___// __ \ / ___// ___/
#                  _  / /_/ // /_/ /(__  )/ / / // /   / /__
#                 (_)/_.___/ \__,_//____//_/ /_//_/    \___/
#

# Setting vi mode in bash
set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-cmd-mode-string \1\e[1m\2[N]\1\e[m\2'
bind 'set vi-ins-mode-string \1\e[1m\2[I]\1\e[m\2'
bind 'set keymap vi-command'
bind 'Control-l: clear-screen'
bind 'set keymap vi-insert'
bind 'Control-l: clear-screen'

#setting prompt
promptstatus () {
    if [[ $? == 0 ]]; then
        echo -n -e '\e[1;92m'
    else
        echo -n -e '\e[1;91m'
    fi
}

readonly () {
    previuosReturn=$?
    if [ ! -w "$(pwd)" ]; then
        echo -n -e '\e[31mREADONLY \e[m'
    fi
    return $previuosReturn
}

PS1='\n$(readonly)\[\e[96m\]\w\[\e[m\]\n \[\e[34m\](\h)\[\e[m\]\[$(promptstatus)\]> \[\e[m\]'

export PS1

complete -cf sudo
# alias

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias more='less'
alias ls='ls -lh --color=auto'
alias ll='ls -alh --color=auto'
alias sync-files="rsync -ah --progress --chmod=+rx"
alias vi='vim'
alias up='uptime -p'
alias ups='uptime -s'

shopt -s checkwinsize
shopt -s expand_aliases
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
