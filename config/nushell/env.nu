# env.nu
#
# Installed by:
# version  =  "0.103.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

# $env.XDG_CONFIG_HOME = $"($nu.home-path)/.config"

$env.VAR = "Hello"

$env.GIT_AUTHOR_NAME = "Jakub Knetl"

# $env.JAVA_HOME = $"($nu.home-path)/.jvm/latest"

$env.BROWSER = 'firefox'
$env.EDITOR = 'nvim'
# $env._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings = lcd -Dsun.java2d.xrender = true"

# directories
$env.storage = $"($nu.home-path)/storage"
$env.projects = $"($nu.home-path)/projects"
$env.tmp = $"($nu.home-path)/tmp"

# solarized skin
$env.MC_SKIN = $"($nu.home-path)/.config/mc_solarized.ini"

$env.DOTNET_ROOT = $"($nu.home-path)/.dotnet"

$env.GOPATH = $"($nu.home-path)/go"
$env.GOBIN = $"($nu.home-path)/go/bin"

$env.PATH ++= ["/usr/local/bin"]
$env.PATH ++= [$"($nu.home-path)/bin"]
$env.PATH ++= [$"($nu.home-path)/.local/bin"]
# $env.PATH ++= [$"($env.JAVA_HOME)/bin"]
$env.PATH ++= ["/opt/bin"]
$env.PATH ++= [$"($nu.home-path)/.dotnet"]
$env.PATH ++= [$"($nu.home-path)/.krew/bin"]
$env.PATH ++= ["/usr/local/go/bin"]
$env.PATH ++= [$env.GOBIN]
$env.PATH ++= [$"($nu.home-path)/.local/share/coursier/bin"]
$env.PATH ++= ["/opt/android-platform-tools"]
$env.PATH ++= [$"($nu.home-path)/Library/Python/3.12/bin"]
$env.PATH ++= [$"($nu.home-path)/.cargo/bin"]

# Use rbenv instead of rvm
# $env.PATH = $"($nu.home-path)/.rbenv/bin"

# $env.ANDROID_HOME = $"($nu.home-path)/Android/Sdk"
# $env.PATH ++= [$"($env.ANDROID_HOME)/tools"]
# $env.PATH ++= [$"($env.ANDROID_HOME)/tools/bin"]
# $env.PATH ++= [$"($env.ANDROID_HOME)/platform_tools"]

$env.dockerized = $"($nu.home-path)/projects/dockerized-tools"

# If you have $shares defined elsewhere, use it; otherwise, set it here.
# $env.shares = $"($nu.home-path)/shares"
# $env.vms = $"($env.shares)/vms"
# $env.local_share = $"($env.shares)/local_share"

# kubernetes labels
$env.klname = "app.kubernetes.io/name"
$env.klinstance = "app.kubernetes.io/instance"
$env.klcomponent = "app.kubernetes.io/component"

# Use dolphin/kde file chooser
# $env.GTK_USE_PORTAL = 1

# The work related stuff is not part of the source code
# if ($"($nu.home-path)/.work.env" | path exists) { 
#   source $"($nu.home-path)/.work.env"
# }

$env.FORGIT_COPY_CMD = 'xclip -selection clipboard'

$env.AWS_PAGER = ""

zoxide init nushell | save -f $"($nu.home-path)/.zoxide.nu"

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir $"($nu.home-path)/.cache/carapace"
carapace _carapace nushell | save --force $"($nu.home-path)/.cache/carapace/init.nu"


source ($nu.home-path | path join '.config/nushell/work.env.nu')
