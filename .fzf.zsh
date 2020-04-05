# Setup fzf
# ---------
if [[ ! "$PATH" == */home/rughi/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/rughi/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/rughi/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/rughi/.fzf/shell/key-bindings.zsh"
