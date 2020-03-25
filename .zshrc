#bindkey
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Set up the prompt

autoload -Uz promptinit
promptinit
#prompt adam1
#theme
[ -f ~/.config/zsh/themes/spaceship-prompt/spaceship.zsh ] && source ~/.config/zsh/themes/spaceship-prompt/spaceship.zsh

setopt histignorealldups sharehistory

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.dotnet/tools:$HOME/.scripts:$HOME/bin:/snap/bin:/usr/local/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export XDG_CONFIG_HOME=$HOME/.config
export TZ=Europe/Rome
export SSH_ASKPASS=$HOME/.scripts/ssh-ask-passwd

export CURRENT_CITY_PATH=$HOME/.cache/umbe/current_city
export WEATHER_CACHE=$HOME/.cache/umbe/weather

export TERMINAL=alacritty
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

#load aliases
source ~/.aliasrc

alias dotfiles='/usr/bin/git --git-dir=/home/rughi/.dotfiles/ --work-tree=/home/rughi'

[ -f ~/.config/colorls/colorls.sh ] && source ~/.config/colorls/colorls.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.config/zsh/plugins/colored-man-pages/colored-man-pages.zsh ] && source ~/.config/zsh/plugins/colored-man-pages/colored-man-pages.zsh

[ -f ~/.config/zsh/plugins/gitignore/gitignore.zsh ] && source ~/.config/zsh/plugins/gitignore/gitignore.zsh

[ -f ~/.config/zsh/plugins/sudo/sudo.zsh ] && source ~/.config/zsh/plugins/sudo/sudo.zsh

[ -f ~/.config/zsh/plugins/docker/_docker ] && source ~/.config/zsh/plugins/docker/_docker

[ -f ~/.config/zsh/bindkey.zsh ] && source ~/.config/zsh/bindkey.zsh

pfetch
