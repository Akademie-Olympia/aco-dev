# Native apps – how to build, theme and test them

Rules and workflow for the native ACO apps (Rust, GTK 4, libadwaita): aco-files, aco-pdf, aco-edit, aco-latex,
aco-images, aco-music, aco-video, aco-settings. Read [CONVENTIONS.md](CONVENTIONS.md) and
[PITFALLS.md](PITFALLS.md) as well.

## Stack and rules

- Rust edition 2021; `gtk4` 0.11.5 (feature `v4_14`), `libadwaita` 0.9.2 (feature `v1_6`); one glib version.
  Release profile: `lto`, `codegen-units = 1`, `panic = "abort"`, `strip`.
- UI text German (like the existing apps), code, comments and docs English. Short, clear names.
- Shared code lives in [aco-common](https://github.com/Akademie-Olympia/aco-common) (Git dependency, pinned by the
  committed `Cargo.lock`; update with `cargo update -p aco-common`). Never copy code from another app: if two apps need
  it, it belongs in aco-common.
- Security: no shell (`std::process::Command`/`gio::Subprocess` with argument vectors), no network unless the feature
  needs it, files are never executed by opening them, secrets only in 0600 files, writes go to a temporary file and
  are renamed into place, untrusted data (images, PDFs, archives, documents) is parsed defensively and never trusted
  for paths.
- New crates: prefer small, well-known, maintained pure-Rust crates; name and justify each in the README.
- Every app: settings in an `adw::PreferencesDialog`, keyboard shortcuts for everything important, a README with
  features, keys, settings and dependencies, `data/org.aco.<App>.desktop`, `packaging/arch/PKGBUILD`
  (`options=('!debug')`, `cargo fetch --locked` / `cargo build --frozen`, all system libraries in `depends`).

## Workspace styling

Use the opt-in `aco-workspace` window class and the shared `aco-titlebar`, `aco-commandbar`, `aco-rail` and
`aco-statusbar` classes from aco-gtk4. Use `aco-primary` for the main action and `aco-tool` for secondary controls.
These surfaces follow the palette and stay opaque while the desktop's panels and menus can use transparency.

## Appearance (theme, own style, transparency)

aco-theme renders the resolved theme to `~/.config/aco/theme/gtk-4.0/tokens.conf` (through aco-gtk4). Every app calls
once at startup (after the first `activate`):

```rust
let appearance = aco_common::appearance::Appearance::init("aco-files"); // Rc<Appearance>
// settings dialog:
dialog.add(&appearance.page()); // page "Darstellung"
appearance.connect_changed(|a| { /* a.is_transparent() … */ });
```

By default the app follows the system profile live (profile, light/dark, accent, transparency). In "Darstellung" each
app can choose its own profile (aco, graphit, kuehl, warm, any palette), mode, accent, transparency on/off with its own
opacity, and edit an own CSS file (`~/.config/aco/apps/<app>.css`, reloaded on save). Choices are stored in
`~/.config/aco/apps/<app>.conf`.

- Never hard-code colours: use libadwaita colours (`@accent_bg_color`, `var(--window-bg-color)`, …).
- With transparency the window, header bar, sidebar and view backgrounds are translucent (Hyprland blurs behind
  them); popovers and dialogs stay solid. Content that must stay readable as a "sheet" (document pages, PDF pages,
  pictures) is drawn opaque by the app.

## Build and test in the VM

The VM (`vm/vm.sh`, x86_64 Arch, Hyprland, German keyboard layout) is shared by everyone working at the same time.

```bash
# copy sources (from the repository folder)
COPYFILE_DISABLE=1 tar --no-xattrs --exclude=target --exclude=.git -cf - . \
  | vm/vm.sh ssh 'mkdir -p ~/src/apps/<app> && tar -C ~/src/apps/<app> -xf -'
# debug build with the shared target folder (dependencies are compiled once; cargo waits for other builds)
vm/vm.sh ssh 'cd ~/src/apps/<app> && CARGO_TARGET_DIR=~/src/target-shared cargo build 2>&1 | tail -30'
# start inside the Hyprland session (an app started directly over ssh has no session environment)
vm/vm.sh hypr "dispatch 'hl.dsp.exec_cmd(\"/home/aco/src/target-shared/debug/<bin> ARGS > /tmp/<app>.log 2>&1\")'"
vm/vm.sh shot                      # screenshot -> vm/images/shot.png (copy it to a unique name at once)
printf 'sendkey ctrl-s\n' | nc -U vm/images/monitor.sock   # keys (German layout: y and z are swapped)
vm/vm.sh ssh 'pkill -x <bin>'      # close your app again
```

- **Screen lock:** the screen is shared. Wrap each GUI sequence (start, keys, screenshot, close) in
  `until mkdir vm/images/gui.lock 2>/dev/null; do sleep 5; done` … `rmdir vm/images/gui.lock` and keep it short.
- Never stop, reset or restart the VM, never touch another app's folders.
- Testing against unpublished aco-common changes: copy your aco-common worktree to `~/src/agents/<you>/aco-common`
  in the VM and add a `.cargo/config.toml` in your VM build folder only:
  `[patch."https://github.com/Akademie-Olympia/aco-common.git"] aco-common = { path = "/home/aco/src/agents/<you>/aco-common" }`.
  Never commit that file.
- Before committing: `cargo build --release --locked` once, copy `Cargo.lock` back
  (`vm/vm.sh ssh 'cat ~/src/apps/<app>/Cargo.lock' > repos/<app>/Cargo.lock`).

## Git

Feature branch in the app's repository (`feat/<topic>`), conventional commits (`feat(files): …`, English, imperative,
≤ 72 characters, one logical change each), then `git merge --no-ff` into `develop`. Pushing and `main` are the lead's
job. Changes to aco-common happen in a worktree (`git -C repos/aco-common worktree add ../../.work/<name> -b
feat/<topic>`), only in the files the task names.
