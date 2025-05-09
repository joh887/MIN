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


# Custom LGIN function to switch AWS profiles and initiate SSO login


LGIN() {
    if [[ -z "$1" ]]; then
        echo "Usage: LGIN <IDENTIFIER>"
        return 1
    fi

    local IDS="$1"
    local PROFILE

    # Map identifiers to AWS profile names
    case "$IDS" in
        dev)
            PROFILE="046955552049_AWSAdministratorAccess"
            ;;
        non_prod)
            PROFILE="014498658256_AWSAdministratorAccess"
            ;;
        prod)
            PROFILE="AWSAdministratorAccess-014498658553"
            ;;
        *)
            echo "Unknown identifier: $IDS"
            echo "Available identifiers: dev, prod, non_prod"
            return 1
            ;;
    esac

    # Export the AWS_PROFILE environment variable
    export AWS_PROFILE="$PROFILE"
    echo "EXPORT AWS_PROFILE"
    echo "$AWS_PROFILE"

    # Initiate AWS SSO login
    echo "LOGGING IN"
    aws sso login --profile "$AWS_PROFILE"
}


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

txt() {
  open -a TextEdit $1
}

#copy from the repo
cz() {
  . /Users/joh887/MIN/ZPASTE.SH
  reload
}

#paste to repo
pz() {
  . /Users/joh887/MIN/ZCOPY.SH
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/Cellar/tfenv/3.0.0/versions/1.8.1/terraform terraform
