# Roadmap

Where the project stands and what comes next. Update the status and tick tasks in the same commit as the work.
Vision and definition of done: [VISION.md](VISION.md). Why things are as they are: [DECISIONS.md](DECISIONS.md).

## Status (2026-11-27)

Done and pushed to `develop` of every repository:
- Desktop: transparent macOS-like bar with Arch menu and workspace circles (per monitor), control centre,
  notification side panel, lock screen, SDDM login, energy menu, wave wallpaper, profiles aco/graphit/kuehl/warm,
  light/dark, accent, transparency.
- Native apps (Rust, GTK 4): settings, file manager (aco-files), Musik (+ mini player, MPRIS), Video, Bilder, PDF,
  Editor; shared crate aco-common.
- Theming of Dolphin/KDE (aco-qt), Obsidian (aco-obsidian) and Code - OSS (aco-code, verified in the VM).
- Packaging: native package definitions, add-on groups, `aco-arch-dotfiles-full`, installer flags
  `--minimal --full --with`, `aco install|remove|groups`. Registry tests and component checks (32) pass in the VM;
  add-on, meta and native packages build with makepkg in the VM (aco-pdf: 396 KB binary).
- aco-files tested in the VM: grid/list, previews, tabs/windows, recursive search, context menu, copy/paste with
  conflict dialog, move with "skip" (skipped files stay), duplicate, new folder, rename, properties, settings, trash
  with undo (Ctrl+Z), SFTP share with the GVfs password dialog, `FileManager1.ShowItems` over D-Bus, "show in
  folder" by argument. Release binary 958 KB, about 65 MB own memory with a folder of pictures open.
- Not exercised yet (need a manual pass with a real mouse/hardware): drag and drop, the "Rückgängig" button in the
  toast, eject/unmount of drives, "open with", compress/extract, SMB shares. aco-code's first-run
  `settings.json` is written correctly; its effect inside Code (no chat panel) was not looked at.

Not done: nothing is on `main` yet, so the signed registry does not contain the new packages. See the release checklist.

### Local development

- Native workspace pass across Settings, Files, Editor, PDF and the media apps. Settings pages are searchable,
  Files has a dedicated address bar, Editor reports syntax and position, and PDF has thumbnail navigation and
  individual search matches. Compact toolbars and lightly translucent chrome preserve readable content surfaces.
- The base and minimal installation include all seven native apps, including Musik, Video and Bilder.

## Release checklist (user step – agents never touch `main`)

1. Merge `develop` → `main` in every component repository first, `aco-arch-dotfiles` last (its `main` lists the new
   repositories; the registry clones their `main`).
2. The new repositories (aco-music, aco-video, aco-images, aco-pdf, aco-edit, aco-media-tools, aco-code, aco-obsidian,
   aco-settings, aco-qt, aco-sddm, aco-rofi, aco-greetd) need the `DOTFILES_DISPATCH_TOKEN` secret (or an
   organisation secret) so their `main` pushes trigger a registry build.
3. Watch the first `packages.yml` run: it installs the native build dependencies and compiles seven apps.
   Until step 1 is done, the component CI on `develop` fails with "Unknown component repository" because it loads
   the checks from `aco-arch-dotfiles` `main` – expected, not a bug.
4. Fresh VM from the base image: `install.sh --full`, then `aco groups`; rebuild the golden image.

## Next tasks (in order)

1. aco-files next steps: split view (F3), batch rename, column-header sorting in the list view, content search,
   remembering the window size, video previews (ffmpegthumbnailer when installed), a D-Bus activation file for
   `org.freedesktop.FileManager1` once Dolphin is gone from most installs. Mouse-driven checks (drag and drop,
   undo button in the toast) still need a manual pass – the QEMU monitor mouse is unreliable.
2. Media keys through `playerctl` in aco-hypr and a float rule for the Musik "Mini-Player" window.
3. Firefox in the ACO look (follows GTK; check whether a small `user.js`/userChrome add-on is worth it).
4. Idle-load check of the whole desktop (RAM/CPU after login) and a note in VISION.md.
5. `aco-common`: when it changes, bump each app with `cargo update -p aco-common` and commit the lock files.

## aco-files – file manager specification (implemented in 0.1.0)

Native Rust + GTK 4/libadwaita app, own repository `aco-files`, package `aco-arch-dotfiles-files` (base group),
command `aco-files`, app id `org.aco.Files`. Goal: everything a user needs from Dolphin, faster and safer.
Module map: `pane.rs` (folder model, views, search, drag and drop), `window.rs` (tabs, actions, shortcuts),
`ops.rs` (threaded file operations), `trash.rs` (undo), `thumbs.rs`, `sidebar.rs`, `pathbar.rs`, `dialogs.rs`,
`clip.rs` (clipboard formats of GNOME/KDE), `dbus.rs` (FileManager1), `settings.rs`.
`aco install <group>` activates only the group's own config modules (`aco-obsidian`, `aco-code`); `base` and
`full` activate everything, so modules the user deactivated stay off.

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
