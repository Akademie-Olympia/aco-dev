# Decisions

Why things are the way they are. One entry per decision: **what**, **where**, **when**, **why**. Newest last.
Add an entry whenever a choice would surprise the next person (or agent) reading the code. Supersede old entries
by adding a new one that names the old number; do not rewrite history.

### D1 – One repository per component, aco-dev as umbrella
- **Where:** `repos/` (git submodules on `develop`), `aco-arch-dotfiles/repositories.json`.
- **Why:** each tool is installable, testable and documented on its own; the umbrella only holds vision, VM and glue.

### D2 – aco-theme is the single source of colours, fonts and geometry
- **Where:** `<component>/aco-theme/*.tpl` (also in subfolders) → `~/.config/aco/theme/<component>/`.
- **How:** tokens `{{token}}`, filters `:hex :rgb :rgba :aNN :xNN` (NN = percent). An unknown token aborts the render.
  Hooks: `aco-theme/reload.sh` after every apply, `aco-theme/session.sh` at login (`aco-theme session`, since 0.2.0).
- **Why:** one change of profile, mode or accent restyles everything; no one-off colours.

### D3 – Native apps in Rust with GTK 4 and libadwaita (2026-11-26)
- **Where:** aco-settings, aco-music, aco-video, aco-images, aco-pdf, aco-edit (and aco-files).
- **Why:** the user wanted real native programs, no Python; Rust gives memory safety and small fast binaries;
  GTK 4 follows the ACO look through aco-gtk4 without extra theming code. Release profile: `lto`, `codegen-units=1`,
  `panic=abort`, `strip`. External commands run without a shell; secrets only through 0600 files.

### D4 – Own media players instead of Celluloid/Amberol (2026-11-26)
- **Where:** aco-music, aco-video, aco-images; defaults in `aco-hypr/defaults.sh`.
- **How:** GStreamer `playbin` + `gtk4paintablesink`; MPRIS via a GDBus object; covers with lofty.
- **Why:** seamless look and behaviour (mini player, control-centre media card) that third-party apps could not give.
  Celluloid/Amberol remain fallbacks in `defaults.sh` only if installed.

### D5 – Shared code in the aco-common crate as a Git dependency (2026-11-27)
- **Where:** `aco-common` repo; each app's `Cargo.toml` + committed `Cargo.lock`.
- **Why:** separate repos per app without copy-paste; not on crates.io, so the lock file pins the exact commit and
  builds stay reproducible (`cargo fetch --locked`, `cargo build --frozen`). Bump with `cargo update -p aco-common`.

### D6 – Every tool its own repo; aco-media-tools is only a group (2026-11-27)
- **Where:** aco-music/video/images + `aco-media-tools/packaging/arch/PKGBUILD` (meta, `arch=any`).
- **Why:** user request; PDF reader and editor are not media – they are separate and belong to the base desktop.

### D7 – Upstream apps from Arch, ACO only adds the theme (2026-11-26)
- **Where:** aco-obsidian, aco-code; Firefox via the `browser` group.
- **Why:** nothing to maintain when Obsidian, Code - OSS or Firefox update; `pacman -Syu` updates them.

### D8 – Code - OSS theme as a generated local extension (2026-11-27)
- **Where:** `aco-code/aco-theme/*.tpl`, `install.sh` → `~/.vscode-oss/extensions/aco.aco-theme-1.0.0`.
- **How:** first run writes a small `settings.json` (theme, fonts, no AI chat panel, telemetry/update off); an
  existing settings file only gets `workbench.colorTheme` if missing. Needs aco-theme ≥ 0.2.0 (`vscode_base`).
- **Why:** no marketplace, no network, follows every theme change.

### D9 – Add-on package names follow the module name (2026-11-27)
- **What:** `aco-arch-dotfiles-aco-code`, `aco-arch-dotfiles-aco-obsidian` (not `-code`/`-obsidian`).
- **Why:** `check-component.py` derives the package name from the module name, and the module name is the
  `~/.config/<module>` directory; `~/.config/obsidian` already belongs to Obsidian itself.

### D10 – Install groups and the standard installation (2026-11-27)
- **Where:** `aco-arch-dotfiles/install.sh`, `packages/aco-arch-dotfiles-core/aco`, `packaging/arch/packages.json`.
- **What:** groups `base media browser obsidian code full`; default = base + media + browser; `"addon"` packages
  never enter the base metapackage `aco-arch-dotfiles`; `aco-arch-dotfiles-full` = base + every add-on + Firefox.
- **Why:** a usable desktop by default, optional extras with one command or one installer flag, all as pacman packages.

### D11 – Native packages in the registry build the staged commit (2026-11-27)
- **Where:** `prepare-source.py` (`"native"` entries, `stage_native`, `--build-deps`), `.github/workflows/packages.yml`.
- **How:** the registry tars the checked-out tracked files to `payload.tar.gz` and rewrites `source=`/`sha256sums=`
  of the app's PKGBUILD; CI installs depends + makedepends first because makepkg runs with `--nodeps`;
  `options=('!debug')` keeps one artefact per package. The Git URL in each PKGBUILD (`#branch=main`) is only for
  standalone `makepkg`.
- **Why:** versions stay `<pkgver>.r<count>.g<commit>` like the config packages, and a package is exactly the commit
  that was checked.

### D12 – Dolphin now, own file manager next (2026-11-26 / 2026-11-27)
- Dolphin was chosen over Nautilus (user) and is themed through aco-qt. On 2026-11-27 the user asked for an own
  file manager in Rust (aco-files) that replaces Dolphin as the default for folders once it is complete.

### D13 – SDDM with an own theme as the login screen (2026-11-26)
- **Where:** aco-sddm (`zz-aco.conf` so it is read after `default.conf`); aco-greetd stays as an alternative.
- **Why:** clock first, round profile picture, last user preselected, only power actions – no bar on the login screen.

### D14 – Electron apps native on Wayland (2026-11-27)
- **Where:** `aco-hypr/hyprland.lua`: `ELECTRON_OZONE_PLATFORM_HINT=auto`. Verified: Code - OSS runs with `xwayland: 0`.

### D15 – Release flow
- Work lands on `develop` (pushed). `main` is changed only by the user at release; the registry builds from `main`
  of every repository. See [ROADMAP.md](ROADMAP.md) for the release checklist.

### D16 – aco-files replaces Dolphin as the default file manager (2026-11-27)
- **Where:** `aco-files` repo; `aco-hypr` (`fileManager`, `defaults.sh`, PKGBUILD); `aco-waybar` (window name).
- **What:** Super+E and `inode/directory` open ACO Dateien; Dolphin, kio-extras, ffmpegthumbs and ark moved from
  hard dependencies of aco-hypr to optdepends (Dolphin stays the fallback in `defaults.sh` if installed).
- **Why:** user request for an own, fast, secure file manager that fits the theme; dropping the KDE stack from the
  base desktop saves disk space and memory. Supersedes the second half of D12.
- **How (security):** all file access through GIO (local, removable and GVfs network locations alike), no shell,
  files are only opened with their registered app (never executed), archives through `bsdtar` (refuses absolute
  paths and `..`), thumbnails private (0600) in the shared freedesktop cache, remote previews off by default.

### D17 – Undo of "move to trash" reads the trash folders directly (2026-11-27)
- **Where:** `aco-files/src/trash.rs`.
- **Why:** GVfs' `trash:///` listing can lag behind a file that was just trashed (seen in the VM); the `.trashinfo`
  files of the freedesktop trash specification are authoritative. `trash:///` remains the fallback.
