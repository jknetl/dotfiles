#!/bin/bash


#profile test
date > $HOME/tmp/profile.latest
echo $0 > "$HOME/tmp/profile.0.arg"

# enable to use gnome-keyring inside of i3

# export keyring daemon if you use lightdm
#if [ "$0" = "/etc/X11/xinit/Xsession" -a "$DESKTOP_SESSION" = "i3" ]; then
    #echo "/etc/sbin/lightdm/" > $HOME/tmp/test-session
    #export $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh)
    #export SSH_AGENT_PID=${GNOME_KEYRING_PID:-gnome}
#fi

# export keyring daemon if you use lightdm
#if [ "$0" = "/usr/sbin/lightdm-session" -a "$DESKTOP_SESSION" = "i3" ]; then
    #echo "/etc/sbin/lightdm/" > $HOME/tmp/test-session
    #export $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh)
    #export SSH_AGENT_PID=${GNOME_KEYRING_PID:-gnome}
#fi

# export keyring daemon if you use gdm
#if [ "$0" = "/etc/gdm/Xsession" -a "$DESKTOP_SESSION" = "i3" ]; then
    #echo "/etc/gdm/Xsession/" > $HOME/tmp/test-session
    #export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    ## SSH_AGENT_PID required to stop xinitrc-common from starting ssh-agent
    #export SSH_AGENT_PID=${GNOME_KEYRING_PID:-gnome}
#fi


### Swap caps and esc
#setxkbmap -option caps:swapescape

#my xmodmap swaps esc with caps
#xmodmap ~/.Xmodmap

# xset rate [delay] [repetition speed] (all in ms)
xset r rate 250 48

#enable numlock
#setleds -D +num


# Base16 Shell
if [ -z "$THEME" ]; then
    export THEME="base16-solarized"
fi
if [ -z "$BACKGROUND" ]; then
    export BACKGROUND="dark"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH="/opt/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# >>> coursier install directory >>>
export PATH="$PATH:$HOME/.local/share/coursier/bin"

if [ -e "$XDG_RUNTIME_DIR/gcr/ssh" ];
  then
    # GCR is new replacement of gnome-keyring agent - see https://wiki.archlinux.org/title/GNOME/Keyring#SSH_keys 
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
elif [ -e "/run/user/$UID/keyring/ssh" ];
   then
    # use old gnome keyring agent if exists
    export SSH_AUTH_SOCK="/run/user/$UID/keyring/ssh"
  else
    echo "ERROR: No keyring agent found. Is it running?"
fi


# <<< coursier install directory <<<
#

# HiDPI scaling
#
#export GDK_SCALE=2
#export GDK_DPI_SCALE=0.5
#export QT_AUTO_SCREEN_SCALE_FACTOR=1
