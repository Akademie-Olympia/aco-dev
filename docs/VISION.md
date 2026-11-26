# Vision

A **slim, secure, stable and good-looking Linux on an Arch base**, built around Hyprland, that is a clean and modern working desktop.

## Goals
- **Arch base + install once.** A plain Arch is the foundation; everything else is installed from our signed pacman registry. Updates are `pacman -Syu` – nothing else.
- **Slim.** Few processes, low idle RAM/CPU. No heavyweight desktop environment, no background daemons without a reason. Every added package or service must be justified.
- **Secure.** Signed packages with a pinned key, no remote code beyond the audited installer, no services enabled silently, least privilege, no secrets in configs.
- **Stable.** Reproducible results; tested in the VM from a golden image before release. User changes are never overwritten (`.pacnew` for new defaults).
- **Consistent look.** One theme everywhere: same palette, font (Nerd Font), icons, cursor, rounding, gaps and spacing across Hyprland, Waybar, terminals, launcher, GTK 3/4, file managers, editors, tmux, yazi.
- **Complete and usable.** All important tools present and working out of the box: terminal, launcher, bar, lock/idle, screenshots, file manager, editor, shell, clipboard, audio, network, monitors, wallpaper.
- **Modular.** One repo per component; each is installable alone and documented in English.

## Non-goals
Not a distribution fork, no custom kernel, no GUI installer (for now), no support for other distros.

## Definition of done for a change
Works in the VM from the golden image, matches the theme, documented, conventional commit, no new idle load without justification.

> The shared theme tokens (palette, fonts, sizes) should be written down in `docs/THEME.md` once chosen. Until then, derive them from the existing configs and do not invent new ones.
