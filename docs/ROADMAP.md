# Roadmap

Where the project stands and what comes next. Update the status and tick tasks in the same commit as the work.
Vision and definition of done: [VISION.md](VISION.md). Why things are as they are: [DECISIONS.md](DECISIONS.md).

## Status (2026-11-27)

Done and pushed to `develop` of every repository:
- Desktop: transparent macOS-like bar with Arch menu and workspace circles (per monitor), control centre,
  notification side panel, lock screen, SDDM login, energy menu, wave wallpaper, profiles aco/graphit/kuehl/warm,
  light/dark, accent, transparency.
- Native apps (Rust, GTK 4): settings, Musik (+ mini player, MPRIS), Video, Bilder, PDF, Editor; shared crate aco-common.
- Theming of Dolphin/KDE (aco-qt), Obsidian (aco-obsidian) and Code - OSS (aco-code, verified in the VM).
- Packaging: native packages in the registry, add-on groups, `aco-arch-dotfiles-full`, installer flags
  `--minimal --full --with`, `aco install|remove|groups`. Registry tests (65) and component checks (31) pass in the VM;
  add-on, meta and native packages build with makepkg in the VM.

Not done: nothing is on `main` yet, so the signed registry does not contain the new packages. See the release checklist.

## Release checklist (user step – agents never touch `main`)

1. Merge `develop` → `main` in every component repository first, `aco-arch-dotfiles` last (its `main` lists the new
   repositories; the registry clones their `main`).
2. The new repositories (aco-music, aco-video, aco-images, aco-pdf, aco-edit, aco-media-tools, aco-code, aco-obsidian,
   aco-settings, aco-qt, aco-sddm, aco-rofi, aco-greetd) need the `DOTFILES_DISPATCH_TOKEN` secret (or an
   organisation secret) so their `main` pushes trigger a registry build.
3. Watch the first `packages.yml` run: it installs the native build dependencies and compiles six apps.
4. Fresh VM from the base image: `install.sh --full`, then `aco groups`; rebuild the golden image.

## Next tasks (in order)

1. **aco-files** – own file manager (spec below). Then `defaults.sh`: `inode/directory` → `org.aco.Files.desktop`,
   Dolphin becomes optional (keep aco-qt for other KDE apps).
2. Media keys through `playerctl` in aco-hypr and a float rule for the Musik "Mini-Player" window.
3. Firefox in the ACO look (follows GTK; check whether a small `user.js`/userChrome add-on is worth it).
4. Idle-load check of the whole desktop (RAM/CPU after login) and a note in VISION.md.
5. `aco-common`: when it changes, bump each app with `cargo update -p aco-common` and commit the lock files.

## aco-files – file manager specification

Native Rust + GTK 4/libadwaita app, own repository `aco-files`, package `aco-arch-dotfiles-files` (base group),
command `aco-files`, app id `org.aco.Files`. Goal: everything a user needs from Dolphin, faster and safer.

- **Views:** grid with thumbnails and list with columns (name, size, type, modified); sort by name/size/type/date,
  ascending/descending, folders first; zoom; remembers the view.
- **Navigation:** breadcrumb path bar, editable location (Ctrl+L, also `smb://`, `sftp://` …), back/forward/up,
  tabs (Ctrl+T/W, Ctrl+Tab), keyboard type-ahead.
- **Sidebar:** places (home and XDG folders, trash), GTK bookmarks (`~/.config/gtk-3.0/bookmarks`), drives and
  volumes (mount/unmount/eject via `gio::VolumeMonitor`), network: "Connect to server" through GVfs with
  `gtk::MountOperation` for credentials (works when `gvfs`, `gvfs-smb`, … are installed).
- **Hidden files:** Ctrl+H, persisted.
- **Search:** instant filter of the current folder; recursive search (Ctrl+F) on a worker thread, streamed results,
  cancellable, optional hidden files.
- **File operations (gio):** copy/cut/paste (also with other file managers via `text/uri-list`), drag and drop,
  move to trash, delete permanently (confirmation), rename (F2), new folder/file, duplicate; progress with cancel;
  conflict handling (replace, skip, keep both).
- **Open:** default app, "open with" (`gtk::FileLauncher` / app chooser), open terminal here, copy path,
  properties (type, size incl. folders computed in the background, permissions, owner, dates), trash view with
  restore and empty.
- **Thumbnails:** images decoded off the UI thread and cached in the freedesktop thumbnail cache; only for local
  files by default.
- **Settings:** show hidden, default view, sort, folders first, single/double click, confirm trash, thumbnails
  (local/all/off), terminal command, start folder. Stored in `~/.config/aco-files/settings.ini`.
- **Security:** no shell; never executes files on open (executables and scripts open as text or ask); remote
  thumbnails off by default; credentials only through GVfs/keyring.
