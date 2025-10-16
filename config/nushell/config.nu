# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.


mkdir ($nu.data-dir | path join "vendor/autoload")

# Load aliases.nu if it exists from the same directory as config.nu
source ($nu.home-path | path join '.config/nushell/aliases.nu')
source ($nu.home-path | path join '.config/nushell/aliases_kubectl.nu')
source ($nu.home-path | path join '.config/nushell/catppuccin_mocha.nu')
source ~/.cache/carapace/init.nu
source ~/.zoxide.nu

starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

$env.config = {
    keybindings: [
	    {
	        # alt+. inserts last argument from previous command
		name: insert_last_token
		modifier: alt
		keycode: char_.
		mode: emacs
		event: [
		    { edit: InsertString, value: " !$" }
		    { send: Enter }
		]
	    }
	]

}

$env.config.show_banner = false

# Import work related stuff (not part of git repo) if the file exists
const work_env = ($nu.home-path | path join '.config/nushell/work.env.nu')
const work_aliases = ($nu.home-path | path join '.config/nushell/work.aliases.nu')
const work_commands = ($nu.home-path | path join '.config/nushell/work.commands.nu')

if ($work_env | path exists) {
    source $work_env
}

if ($work_aliases | path exists) {
    source $work_aliases
}

if ($work_commands | path exists) {
    source $work_commands
}





