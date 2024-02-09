# enable this for profiling (and then run zprof after zsh startup to see results)
#zmodload zsh/zprof
#
autoload -Uz compinit
compinit


source ~/.antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
#antigen bundle git
antigen bundle pip
antigen bundle docker
antigen bundle docker-compose
antigen bundle fd
antigen bundle fzf
antigen bundle helm
antigen bundle kubectl
antigen bundle kube-ps1
antigen bundle nvm
antigen bundle z
antigen bundle command-not-found
antigen bundle sudo
antigen bundle web-search
antigen bundle dirhistory

antigen bundle 'wfxr/forgit'

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Fish-like autosuggestions
antigen bundle zsh-users/zsh-autosuggestions

# Last command exit status
antigen bundle zpm-zsh/pr-return

# Load the theme.
antigen theme muse
# Other themes I like: lambda, mikeh, minimal, muse, simple, sorin, superjarin

#notification on long running command (default 30s)
antigen bundle marzocchi/zsh-notify

# Tell Antigen that you're done.
antigen apply



# Source my custom environment variables, functions and aliases
#
if [ -f ~/.env ]; then
    source ~/.env
fi
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
if [ -f ~/.functions ]; then
    source ~/.functions
fi


### Plugin specific settings

# Enable option stacking for docker commands (see https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# marzocchi/zsh-notify configuration
zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"

#kubectl autocompletion (the plugin doesn't work):
# The following two modules (compinit and bashcompinit) are needed to get auto
# completion to work: https://github.com/ohmyzsh/ohmyzsh/issues/6323

source <(kubectl completion zsh)
source $HOME/.zsh-completion/az.completion


# FZF history search with key up
#bindkey "${key[Up]}" fzf-history-widget

#Kubectx prompt
#
# left prompt
PROMPT=''$PROMPT'[$pr_return] '
# right prompt
RPS1='$(kube_ps1)'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
# too slow!
# [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# do this instead:
sdk () {
    # "metaprogramming" lol - source init if sdk currently looks like this sdk function
    if [[ "$(which sdk | wc -l)" -le 10 ]]; then
        unset -f sdk
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
    fi
    sdk "$@"
}


timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

#SSH agent
#if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    #ssh-agent -t 8h > "$XDG_RUNTIME_DIR/ssh-agent.env"
#fi
#if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    #source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
#fi

export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

source /opt/bash-my-gcp/loader.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/google-cloud-sdk/completion.zsh.inc'; fi
