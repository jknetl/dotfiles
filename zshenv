# This is useful when zsh is default shell and AwesomeWM is used
# without this, the path modified in zshrc is visible only in terminal
# but Awesome WM cannot execute binaries on custom path directly (e.g. with keybindings)
export PATH="$HOME/bin:/opt/bin:$PATH:/usr/local/go/bin"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm for linux
