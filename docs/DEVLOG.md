# Development log

Short, dated notes of what was done in each working session and where. Newest first. Details live in the commits
of the component repositories; decisions in [DECISIONS.md](DECISIONS.md).

## 2026-11-27
- **Code - OSS theming** (aco-code): generated colour theme + first-run settings; verified in the VM (native
  Wayland, colours match the palette). aco-theme 0.2.0 adds `vscode_base` and login hooks.
- **Repository split:** aco-media-tools became a meta package; aco-music, aco-video, aco-images, aco-pdf, aco-edit and
  the shared crate aco-common have their own repositories. Each app builds alone with a committed `Cargo.lock`.
- **Registry** (aco-arch-dotfiles): native packages, add-ons, `aco-arch-dotfiles-full`, build dependencies in CI,
  component checks for native apps (lock file, desktop entries); install groups in `install.sh` and `aco`.
- **aco-hypr:** default apps are the ACO apps (fallback Celluloid/Amberol), players and Firefox no longer hard
  dependencies, Electron on Wayland.
- **GitHub:** created the public repositories aco-music, aco-video, aco-images, aco-pdf, aco-edit, aco-media-tools,
  aco-code, aco-obsidian, aco-settings, aco-qt, aco-sddm, aco-rofi, aco-greetd; pushed `develop` everywhere.
- **aco-dev:** registered the new submodules; this knowledge base (COMPONENTS, DECISIONS, ROADMAP, DEVLOG, PITFALLS).
- **aco-files:** new file manager (Rust, GTK 4) written and tested in the VM; fixed during testing: a RefCell borrow
  held across `if let` (crash on "up"), lost preview callbacks on rebinding, paste going into the selected folder,
  focus loss after menus (file shortcuts now on the window in the bubble phase), unreliable `trash:///` for undo.
  Registered as a native base package; aco-hypr uses it for Super+E and folders, Dolphin is optional.
- **CI:** native app repositories got the package workflow; develop CI stays red until the release merge (ROADMAP).

## 2026-11-26
- Bar, control centre, notification side panel, Arch menu, energy menu, lock screen and SDDM login redesigned.
- Profiles graphit, kuehl, warm next to aco; settings app aco-settings (Rust); Dolphin themed through aco-qt.
- First versions of the native media apps, PDF reader and editor (then still one workspace in aco-media-tools).
- Obsidian snippet for every vault (aco-obsidian); Catppuccin leftovers removed from tmux, docs and vim.
