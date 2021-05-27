## Keybindings section
bindkey -v
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                     # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action# Set up the prompt
fpath+=$HOME/.config/zsh/pure
autoload -Uz promptinit
promptinit

# luarocks configuration
if [[ -n "`which luarocks 2>/dev/null`" ]]; then
    eval `luarocks path --bin`
fi

eval "$(starship init zsh)"
## Edit command line
autoload -U edit-command-line ; zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

#theme
#[ -f ~/.config/zsh/themes/spaceship-prompt/spaceship.zsh ] && source ~/.config/zsh/themes/spaceship-prompt/spaceship.zsh

#spaceship_vi_mode_enable

setopt histignorealldups sharehistory

# If you come from bash you might have to change your $PATH.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
source ~/.pathdef
#export PATH=$HOME/.gem/ruby/2.7.0/bin:$HOME/.dotnet/tools:$HOME/.scripts:$HOME/bin:/snap/bin:/usr/local/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH
export GOPATH=$HOME/go
export GOBIN=$GOPATH/go
#export PATH=$PATH:$GOPATH/bin
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export XDG_CONFIG_HOME=$HOME/.config
export TZ=Europe/Rome
export SSH_ASKPASS=$HOME/.scripts/ssh-ask-passwd

export DENO_INSTALL=$HOME/.deno
export PATH=$DENO_INSTALL/bin:$PATH

#export CURRENT_CITY_PATH=$HOME/.cache/umbe/current_city
#export WEATHER_CACHE=$HOME/.cache/umbe/weather


export TERMINAL=kitty

export EDITOR=nvim

if [ -f ~/.config/myconfigs/variables ]; then
    source ~/.config/myconfigs/variables
else
    export BROWSER=chromium
fi
# Use emacs keybindings even if our EDITOR is set to vi
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.

# Use emacs keybindings even if our EDITOR is set to vi
#bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# zsh parameter completion for the dotnet CLI

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

#load aliases
source ~/.aliasrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#export FZF_DEFAULT_OPTS='
#--color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C
#--color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B
#'

[ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.config/zsh/plugins/colored-man-pages/colored-man-pages.zsh ] && source ~/.config/zsh/plugins/colored-man-pages/colored-man-pages.zsh

[ -f ~/.config/zsh/plugins/gitignore/gitignore.zsh ] && source ~/.config/zsh/plugins/gitignore/gitignore.zsh

[ -f ~/.config/zsh/plugins/sudo/sudo.zsh ] && source ~/.config/zsh/plugins/sudo/sudo.zsh

[ -f ~/.config/zsh/plugins/docker/_docker ] && source ~/.config/zsh/plugins/docker/_docker

[ -f ~/.config/zsh/bindkey.zsh ] && source ~/.config/zsh/bindkey.zsh

#source ~/.cache/wal/colors.sh
#cat ~/.cache/wal/sequences

test -r "~/.config/myconfigs/dir_colors" && eval $(dircolors ~/.config/myconfigs/dir_colors)

neofetch

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
