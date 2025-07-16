### Deliberately overriden commands
#alias bat = batcat --theme=base16
alias cat = bat --plain
alias catp = bat
alias catt = /usr/bin/cat
alias vim = nvim
alias nv = nvim
alias v = vim

# alias ls = exa
# alias ll = exa -l --icons --git
# alias lt = exa --tree --icons
# alias llt = exa -l --tree --icons --git
def --env ff [] { cd (fd --type d | fzf | str trim) }

# my pomodoro app
alias pomodoro = pomodoro -g

alias manw = man -Hfirefox

# tmux
alias t = tmux
alias td = tmux-default
alias mux = tmuxinator start
alias ta = tmux a
alias tn = tmux new-session
alias tcs = tmux choose-session
def trws [] { tmux rename-window (shorten-path.sh (pwd)) }
def trw [] { tmux rename-window (pwd | path basename) }

# alias restart-plasma = kquitapp5 plasmashell; kstart5 plasmashell

# git
# alias git-get-filemode-changes = git diff --summary | grep --color "mode change" | cut -d" " -f7-
# alias git-revert-filemode-changes = git diff --summary | grep --color "mode change" | cut -d" " -f7- | xargs -e"\n" chmod # needs to specify mode
# alias git-check-merge = git merge --no-ff --no-commit bugfix/TM-3613-smazani-vychozi-sablony; git merge --abort
alias g = git
alias lg = lazygit
alias gcb = git branch --show-current
alias grr = git rev-parse --show-toplevel
def --env cgr [] { cd (git rev-parse --show-toplevel | str trim) }
def ghash [] { git rev-parse --short HEAD | str trim }
def ghashfull [] { git rev-parse HEAD | str trim }
def --env cdgroot [] { cd (git rev-parse --show-toplevel | str trim) }
alias groot = git rev-parse --show-toplevel

def --env ffg [] { cdgroot; ff }

# C programming
alias gdbb = gdb --tui

# maven
alias m = mvn
alias mi = mvn install
alias mci = mvn clean install
alias magp = mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.1

# gradle
alias gw = ./gradlew
alias grcb = gradle clean build
alias grcbx = gradle clean build -x test
def kill-gradle [] { jps | grep -i gradle | cut -d " " -f 1 | each { |pid| kill -9 $pid } }

# ssh
alias sshnhk = ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
alias scpnhk = scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null

# rdesktop
alias frdesktop = rdesktop -k us -r clipboard:CLIPBOARD -z -P -x lan -g 1920x1010 -K

# xclip
alias xclipc = xclip -selection clipboard
alias xcc = xclip -selection clipboard
alias xc = xclip -selection clipboard
alias xp = xclip -o -selection clipboard
def xcp [] { xclip -selection clipboard; xp }

# pbcopy (MacOs xclip alternative)
alias pb = pbcopy

# camera import (BROKEN in NU)
# def import-camera [] { import-camera.sh $"($env.HOME)/storage/fotky-import/tmp-($(date +%Y%m%d%H%M))" }
# def backup-photos [] { backup-photos.sh $"($env.HOME)/storage/fotky/" "/$media/SeagateBackupPlus/multimedia/fotky/" }
# def backup-videos [] { backup-photos.sh $"($env.HOME)/storage/videa/" "/$media/SeagateBackupPlus/multimedia/Videa/" }

#docker
alias d = docker
alias dc = docker-compose

# replaced  by .kubectl_aliases
#alias k = kubectl
#alias kg = kubectl get
#alias kgp = kubectl get pods
#alias kd = kubectl describe
#alias kdp = kubectl describe pods
#alias kl = kubectl logs
alias kx = kubectx
alias kxl = kubie ctx
alias ks = kubens
alias ksl = kubie ns
#alias kexec = kubectl exec --stdin --tty
alias kon = kubeon
alias koff = kubeoff

def --wrapped knetshoot [...rest] {
    # Define the full image string with interpolation
    let image_name = $"($env.DOCKER_IO_REGISTRY)/nicolaka/netshoot"

    # Call the command with the variable
    kubectl run jknetl-debug --rm -i --tty --image $image_name ...$rest
}

alias f = flux

alias b64 = base64
alias b64d = base64 -d

alias gcl = gcloud

alias gl = glab
# terraform
alias tf = terraform

alias p = pulumi
alias pl = pulumi

#python
# def venv [] { source ./venv/bin/activate }
alias venv-exit = deactivate

#date
alias date-prefix = ^date +%Y%m%d
alias _date = date-prefix
alias time-prefix = ^date +%H%M
alias _time = time-prefix
alias time2-prefix = ^date +%H%M%S
alias _time2 = time2-prefix
alias datetime-prefix = ^date +%Y%m%d%H%M
alias _datetime = datetime-prefix
alias datetime2-prefix = ^date +%Y%m%d%H%M%S
alias _datetime2 = datetime2-prefix

def --env awsp [] { $env.AWS_PROFILE = (aws-profile.sh | str trim )}

def awsr [] { let output = (aws-role.sh | str trim); if $output != "" { $env.MY_NAME = $output } }
alias awsl = aws sso login

alias sl = screen-layout

alias evolution = GTK_THEME=Arc evolution

# Sourcing other alias files is not directly supported in Nushell, but you can use 'source' if the files are Nushell scripts:
# if ([$env.HOME/.work.aliases] | path exists) { source $"($env.HOME)/.work.aliases" }
# if ([$env.HOME/.kubectl_aliases] | path exists) { source $"($env.HOME)/.kubectl_aliases" }
