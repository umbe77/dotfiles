# Setup fzf
# ---------
if [[ ! "$PATH" == */home/roberto/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/roberto/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/roberto/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/roberto/.fzf/shell/key-bindings.zsh"
