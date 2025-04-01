# Path to your oh-my-zsh installation
export ZSH="/Users/joh887/.oh-my-zsh"

# Which plugins to load.
# - zsh-autosuggestions: inline suggestions as you type (grey text).
# - zsh-completions: extended tab completions for many commands.
# - git: standard oh-my-zsh git plugin.
plugins=(
  git
  zsh-autosuggestions
  zsh-completions
)

# Load oh-my-zsh (this automatically loads the above plugins).
source $ZSH/oh-my-zsh.sh

# Be sure to load compinit if needed; oh-my-zsh does it by default.
# autoload -Uz compinit && compinit

# ------------------------------------------------------------------------------
# CUSTOM FUNCTIONS AND CONFIG
# ------------------------------------------------------------------------------

# 1) A custom function to display 'ls -la' of whatever is typed if it is a directory
function show_ls {
  local prefix="${LBUFFER}"  # The text typed so far
  if [[ -d "$prefix" ]]; then
    LBUFFER=$prefix
    zle redisplay
    ls -la "$prefix" --group-directories-first
  fi
}
# Register it as a ZLE widget (but we WON'T bind it to Tab):
zle -N show_ls

# 2) CUSTOM COMPLETION STYLES
# These lines customize how tab completion behaves.
zstyle ':completion:*' menu select=long-list
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _complete _files _correct _prefix _ignored
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' \
  'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' accept-exact 'true'
zstyle ':completion:*' use-cache yes

# Instead of binding Tab to our custom function, we let expand-or-complete handle it:
bindkey '^I' expand-or-complete

bindkey '\e ' autosuggest-accept


# ------------------------------------------------------------------------------
# OTHER ALIASES / FUNCTIONS
# ------------------------------------------------------------------------------

# A function to open your ~/.zshrc in TextEdit
MIN() {
  open -a TextEdit ~/.zshrc
}

# Another function to open AWS config in TextEdit
AWS_config() {
  open -a TextEdit ~/.aws/config
}

# Reload function to source ~/.zshrc
reload() {
  source ~/.zshrc
}

# Example Python venv function
venv() {
  python3 -m venv env
  source env/bin/activate
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/Cellar/tfenv/3.0.0/versions/1.8.1/terraform terraform
