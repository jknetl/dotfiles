# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles repository. Configs are symlinked into `$HOME` via the `./install` script. The user's primary shell is **Nushell** (`nu`), with Zsh as a fallback.

## Installation

```bash
# Clone with submodules (base16-shell, tpm, nvchad)
git clone --recurse-submodules https://github.com/jknetl/dotfiles.git

# Backup existing configs
./install -b

# Symlink all configs into $HOME
./install -l

# Link custom nvim config into nvchad (if using neovim)
ln -s $(pwd)/config/nvim/lua/custom /Users/jakub.knetl/dotfiles/modules/nvchad/lua/custom
```

The install script manages three categories:
- **CONFIGS**: symlinked to `~/.<path>` (e.g. `tmux.conf` → `~/.tmux.conf`)
- **SCRIPTS**: symlinked to `~/bin/`
- **MODULES**: git submodules linked as directories (e.g. `modules/base16-shell` → `~/.base16-shell`)

## Architecture

### Shell Configuration
- **Nushell** (`config/nushell/`): primary shell. Config split into `config.nu`, `env.nu`, `aliases.nu`, `aliases_kubectl.nu`. Work-specific files (`work.env.nu`, `work.aliases.nu`, `work.commands.nu`) are machine-local and not tracked.
- **Zsh** (`zshrc`, `aliases`, `functions`, `env`): fallback shell. Uses antigen for plugin management (oh-my-zsh base + zsh-syntax-highlighting, zsh-autosuggestions). Starship prompt.
- **Starship** (`config/starship.toml`): prompt used in both Nushell and Zsh.

### Window Management (macOS)
- **AeroSpace** (`aerospace.toml`): primary tiling WM (i3-style). Alt+hjkl for focus, Alt+Shift+hjkl for move, Alt+1-9 for workspaces.
- **Rift** (`config/rift/config.toml`): alternative tiling WM config (traditional layout, virtual workspaces).
- **Borders** (`config/borders/bordersrc`): window border highlighting.

### Terminal
- **Ghostty** (`config/ghostty/config`): default terminal. Uses Catppuccin Mocha theme, MesloLGS NF font, Nushell as default shell.
- **Alacritty** (`config/alacritty/`): alternative terminal. Host-specific config in `~/.config/alacritty/host-specific.toml` (not tracked).

### Tmux (`tmux.conf`)
- Prefix: `C-Space`
- Window switching: `C-,` / `C-.`
- Copy mode: vi bindings, Escape to enter
- Plugins managed via TPM (`modules/tpm`): catppuccin, vim-tmux-navigator, resurrect, yank, fzf-url, fzf-session-switch
- Tmuxinator sessions in `config/tmuxinator/` (dotfiles, notes, tmp)

### Editor
- Neovim with NvChad base (`modules/nvchad`). Custom config in `config/nvim/lua/custom/`.

### Key Aliases
- `vim`/`nv`/`v` → nvim
- `g` → git, `lg` → lazygit
- `t`/`td`/`mux` → tmux/tmux-default/tmuxinator
- `k` (kubectl from `.kubectl_aliases`), `kx`/`kxl` → kubectx/kubie ctx
- `tf` → terraform, `f` → flux, `p`/`pl` → pulumi

### Scripts (`scripts/`)
Notable utilities:
- `kubeconfig-delete-context.nu`, `rancher-get-all-configs.nu` — Kubernetes context management (Nushell)
- `argo-annotate.nu` — ArgoCD annotation helper
- `aerospace-reposition-windows.sh`, `aerospace-remove-ghost-windows.sh` — AeroSpace helpers
- `aws-profile.sh`, `aws-role.sh` — AWS credential switching
- `tmux-default` — default tmux session setup

### Git Config (`gitconfig`)
- Pull strategy: rebase
- Auto-setup remote on push
- Rerere enabled with auto-update
- Histogram diff algorithm
- Useful aliases: `lod` (log --oneline --graph --decorate), `fpush` (force-with-lease), `blamew/blamewc/blamewccc`

### Work-Specific Files (not tracked)
These files are expected to exist on the machine but are not in the repo:
- `~/.work.env` / `~/.work.gitconfig` / `~/.work.aliases`
- `~/.config/nushell/work.env.nu` / `work.aliases.nu` / `work.commands.nu`
- `~/.config/alacritty/host-specific.toml`

## Adding New Configs

1. Add the config file to the repo.
2. Add its path to the appropriate array (`CONFIGS` or `SCRIPTS`) in `./install`.
3. Run `./install -l` to create the symlink.
