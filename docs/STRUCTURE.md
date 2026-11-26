# Structure

```
aco-dev/
├── AGENTS.md              entry point for agents
├── docs/                  VISION, STRUCTURE, CONVENTIONS (cross-repo)
├── .agents/skills/        playbooks for agents
├── vm/                    QEMU Arch VM (vm.sh, gui.command)
└── repos/                 git submodules (branch: develop)
    ├── aco-arch-dotfiles  installer, signed pacman registry, packaging, repositories.json
    ├── aco-docs           docs of the small components
    ├── aco-theme          theme engine: palettes, light/dark, accents, transparency
    ├── aco-greetd         login screen (greetd + ReGreet + cage), system module below /usr
    └── aco-{foot,fuzzel,ghostty,gtk3,gtk4,hypr,kitty,libfm,nvim,pcmanfm,
             rofi,swaync,tmux,vim,wallpaper,waybar,yazi,zsh}   one config each
```

## Component -> installed path
`aco-theme` -> `~/.config/aco-theme` (command `aco-theme`, output in `~/.config/aco/theme/`); `foot fuzzel ghostty hypr kitty libfm nvim pcmanfm rofi swaync tmux vim waybar yazi zsh` -> `~/.config/<name>`; `greetd` is a system module (`/usr/share/arch-dotfiles/greetd`, `/usr/bin/aco-greeter`, admin copies in `/etc/aco-greetd`) and is not synced by `vm.sh`; `gtk3` -> `~/.config/gtk-3.0`; `gtk4` -> `~/.config/gtk-4.0`; `wallpaper` -> wallpaper config/assets. `vm.sh sync` uses this mapping.

## Flow
1. Edit a component in `repos/aco-<x>` on a feature branch.
2. `vm/vm.sh sync <x>` + `vm/vm.sh shot` to check it live.
3. Commit in the component repo, then commit the new submodule pointer in aco-dev.
4. At the end: release (see `release-finalize` skill): merge to `main`, build packages, publish registry, rebuild golden image.

## Clone everything
```bash
git clone --recurse-submodules <aco-dev-url> && cd aco-dev
```
