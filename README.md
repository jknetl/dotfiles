# Dotfiles

This repository contains currently used configuration of my software.

## Prerequisitis

- zsh installed
- [Nerd fonts](https://www.nerdfonts.com/) installed and configured in terminal app
- [exa](https://github.com/ogham/exa) ls replacement
- tmux
- neovim

### Additional software

Not a prerequisity but this configures lots of software which is expected to be installed, mostly:

- neovim
- tmux


## Installation

```bash
git clone --recurse-submodules https://github.com/jknetl/dotfiles.git && cd dotfiles

# Optionally create backup of current configs
./install -b 

# Replace configs with the links to this repository
./install -l
```


