# Components

Inventory of every repository under `repos/` (all public in the GitHub organisation `Akademie-Olympia`, working
branch `develop`). Keep this table current whenever a component is added, renamed or changes its package.

Kinds: **module** = configuration activated into `~/.config/<module>`; **system** = files below `/usr`, not activated
per user; **native** = compiled app (Rust, GTK 4, libadwaita) built by its own PKGBUILD; **add-on** = optional install
group, never part of the base metapackage; **library** / **tooling** = no package of its own.

## Desktop (base group)

| Repo | Kind | Package | Installs to / command | Purpose |
| --- | --- | --- | --- | --- |
| aco-theme | module | `aco-arch-dotfiles-aco-theme` (0.2.0) | `~/.config/aco-theme`, `aco-theme` | theme engine: profiles, light/dark, accent, transparency; renders every `*.tpl` |
| aco-hypr | module | `aco-arch-dotfiles-hypr` | `~/.config/hypr` | Hyprland, lock/idle, screenshots, energy and system menus, default apps (`defaults.sh`) |
| aco-waybar | module | `aco-arch-dotfiles-waybar` | `~/.config/waybar` | transparent top bar: Arch menu, workspace circles, status icons |
| aco-swaync | module | `aco-arch-dotfiles-swaync` | `~/.config/swaync` | notifications, control centre, notification side panel, media card |
| aco-rofi | module | `aco-arch-dotfiles-rofi` | `~/.config/rofi`, `aco-menu` | Spotlight-like launcher and menus |
| aco-wallpaper | module | `aco-arch-dotfiles-wallpaper` | `~/.config/wallpaper`, `wallpaper` | multi-monitor wallpaper CLI, default wave wallpaper |
| aco-kitty, aco-foot, aco-ghostty | module | `aco-arch-dotfiles-<name>` | `~/.config/<name>` | terminals |
| aco-fuzzel | module | `aco-arch-dotfiles-fuzzel` | `~/.config/fuzzel` | alternative launcher |
| aco-tmux, aco-zsh, aco-nvim, aco-vim, aco-yazi | module | `aco-arch-dotfiles-<name>` | `~/.config/<name>` | terminal-first tools |
| aco-gtk3, aco-gtk4 | module | `aco-arch-dotfiles-gtk-3.0`, `-gtk-4.0` | `~/.config/gtk-3.0`, `gtk-4.0` | GTK look (also styles the native apps) |
| aco-qt | module | `aco-arch-dotfiles-qt6ct` | `~/.config/qt6ct` | Qt/KDE apps through qt6ct + KDE colour scheme (Dolphin is optional since aco-files) |
| aco-libfm, aco-pcmanfm | module | `aco-arch-dotfiles-<name>` | `~/.config/<name>` | legacy file-manager settings |
| aco-sddm | system | `aco-arch-dotfiles-sddm` | `/usr`, `aco-login` | login screen (SDDM theme: clock first, then picture and password) |
| aco-greetd | system | `aco-arch-dotfiles-greetd` | `/usr`, `aco-greeter` | older login alternative (greetd + ReGreet) |
| aco-settings | native | `aco-arch-dotfiles-settings` | `aco-settings` | searchable settings for displays, sound, Bluetooth, networking, energy and appearance |
| aco-files | native | `aco-arch-dotfiles-files` | `aco-files` (`org.aco.Files`) | file manager (Super+E, default for folders): tabs, grid/list, search, network, previews, trash with undo |
| aco-pdf | native | `aco-arch-dotfiles-pdf` | `aco-pdf` (`org.aco.Pdf`) | PDF reader (Poppler): page thumbnails, search and fit controls |
| aco-edit | native | `aco-arch-dotfiles-edit` | `aco-edit` (`org.aco.Edit`) | UTF-8 editor (GtkSourceView): highlighting, search and replace, cursor position |
| aco-media-tools | native (meta) | `aco-arch-dotfiles-media-tools` | – | installs Musik, Video and Bilder together |
| aco-music | native | `aco-arch-dotfiles-music` | `aco-music` | library, queue, mini player and MPRIS |
| aco-video | native | `aco-arch-dotfiles-video` | `aco-video` | subtitles, audio tracks, resume and skip controls |
| aco-images | native | `aco-arch-dotfiles-images` | `aco-images` | gallery, compare, crop, slideshow and image dimensions |

## Add-on groups

| Group | Repo | Kind | Package | Purpose |
| --- | --- | --- | --- | --- |
| browser | – | Arch package | `firefox` | from the Arch repositories |
| obsidian | aco-obsidian | module | `aco-arch-dotfiles-aco-obsidian` | Obsidian (Arch) + ACO CSS snippet in every vault |
| code | aco-code | module | `aco-arch-dotfiles-aco-code` | Code - OSS (Arch) + generated ACO colour theme |
| full | – | meta | `aco-arch-dotfiles-full` | base + all add-ons + Firefox |

## Libraries and tooling

| Repo | Purpose |
| --- | --- |
| aco-common | Rust crate shared by the native apps (app start, dialogs, helpers, GStreamer `Player` behind feature `player`). Used as a Git dependency, pinned by each app's `Cargo.lock`. |
| aco-arch-dotfiles | installer (`install.sh`), `aco` command, signed pacman registry, packaging (`packaging/arch/`), `repositories.json`. |
| aco-docs | shared documentation of the small components (Read the Docs). |

## Install groups

`install.sh` without options installs **standard** = `base browser`. Options: `--minimal` (base), `--full`,
`--with a,b`, or package names. After installation: `aco install <group>`, `aco remove <group>`, `aco groups`.
The group table lives twice (in `install.sh` and in `packages/aco-arch-dotfiles-core/aco`); a test keeps them equal.

The `media` group is also available on its own. The base desktop already requires it.
