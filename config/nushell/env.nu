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

# $env.XDG_CONFIG_HOME = $"($nu.home-dir)/.config"

$env.VAR = "Hello"

$env.GIT_AUTHOR_NAME = "Jakub Knetl"

# $env.JAVA_HOME = $"($nu.home-dir)/.jvm/latest"

$env.BROWSER = 'firefox'
$env.EDITOR = 'nvim'
# $env._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings = lcd -Dsun.java2d.xrender = true"

# directories
$env.storage = $"($nu.home-dir)/storage"
$env.projects = $"($nu.home-dir)/projects"
$env.tmp = $"($nu.home-dir)/tmp"

# solarized skin
$env.MC_SKIN = $"($nu.home-dir)/.config/mc_solarized.ini"

$env.DOTNET_ROOT = $"($nu.home-dir)/.dotnet"

$env.GOPATH = $"($nu.home-dir)/go"
$env.GOBIN = $"($nu.home-dir)/go/bin"

$env.PATH ++= ["/usr/local/bin"]
$env.PATH ++= [$"($nu.home-dir)/bin"]
$env.PATH ++= [$"($nu.home-dir)/.local/bin"]
# $env.PATH ++= [$"($env.JAVA_HOME)/bin"]
$env.PATH ++= ["/opt/bin"]
$env.PATH ++= [$"($nu.home-dir)/.dotnet"]
$env.PATH ++= [$"($nu.home-dir)/.krew/bin"]
$env.PATH ++= ["/usr/local/go/bin"]
$env.PATH ++= [$env.GOBIN]
$env.PATH ++= [$"($nu.home-dir)/.local/share/coursier/bin"]
$env.PATH ++= ["/opt/android-platform-tools"]
$env.PATH ++= [$"($nu.home-dir)/Library/Python/3.12/bin"]
$env.PATH ++= [$"($nu.home-dir)/.cargo/bin"]

# Use rbenv instead of rvm
# $env.PATH = $"($nu.home-dir)/.rbenv/bin"

# $env.ANDROID_HOME = $"($nu.home-dir)/Android/Sdk"
# $env.PATH ++= [$"($env.ANDROID_HOME)/tools"]
# $env.PATH ++= [$"($env.ANDROID_HOME)/tools/bin"]
# $env.PATH ++= [$"($env.ANDROID_HOME)/platform_tools"]

$env.dockerized = $"($nu.home-dir)/projects/dockerized-tools"

# If you have $shares defined elsewhere, use it; otherwise, set it here.
# $env.shares = $"($nu.home-dir)/shares"
# $env.vms = $"($env.shares)/vms"
# $env.local_share = $"($env.shares)/local_share"

# kubernetes labels
$env.klname = "app.kubernetes.io/name"
$env.klinstance = "app.kubernetes.io/instance"
$env.klcomponent = "app.kubernetes.io/component"

# Use dolphin/kde file chooser
# $env.GTK_USE_PORTAL = 1

# The work related stuff is not part of the source code
# if ($"($nu.home-dir)/.work.env" | path exists) { 
#   source $"($nu.home-dir)/.work.env"
# }

$env.FORGIT_COPY_CMD = 'xclip -selection clipboard'

$env.AWS_PAGER = ""

zoxide init nushell | save -f $"($nu.home-dir)/.zoxide.nu"

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir $"($nu.home-dir)/.cache/carapace"
carapace _carapace nushell | save --force $"($nu.home-dir)/.cache/carapace/init.nu"


source ($nu.home-dir | path join '.config/nushell/work.env.nu')

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
