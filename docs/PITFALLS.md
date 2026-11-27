# Pitfalls

Things that cost time once. Read before debugging in the VM or the registry.

- **`pkill -f <pattern>` over ssh kills your own shell** when the pattern appears in the command line you sent
  (`pkill -f sddm-greeter-qt6`, `pkill -f /usr/lib/code`). Use `pkill -x <name>` or an anchored pattern.
- **GUI apps from ssh:** start them through Hyprland so they get the session environment:
  `vm/vm.sh hypr "dispatch 'hl.dsp.exec_cmd(\"code /path\")'"`. Electron's CLI launcher detaches and dies with the
  ssh session otherwise. Check with `vm/vm.sh hypr clients` (`xwayland: 0` = native Wayland).
- **Unknown theme token aborts the whole render.** After adding a token to aco-theme run `vm/vm.sh sync theme`
  before syncing a component whose template uses it, and raise the component's `aco-arch-dotfiles-aco-theme>=` bound.
- **Template alpha:** `:xNN` gives `rrggbbAA` without `#` and NN is a percentage (`{{accent:x40}}`, not `xe0`).
- **Hyprland Lua dispatchers:** an invalid argument (e.g. `id=`) can crash Hyprland; use `workspace=` forms only.
- **Registry tests need Linux:** macOS lacks `flock` and Python ≥ 3.11 (`tomllib`). Run them in the VM:
  copy `repos/` to `~/src/registry` and run `python3 -B -m unittest discover -s packaging/arch/tests` there.
  Absorbed submodules (`.git` is a file) must get their real Git directory first.
- **Package name = `aco-arch-dotfiles-` + module name** for config modules; the module name is the
  `~/.config/<module>` directory (see D9).
- **Native PKGBUILDs:** keep `options=('!debug')`, otherwise makepkg emits a second `-debug` package and the
  registry build stops ("Expected one output").
- **GTK `Pixbuf` is not `Send`:** decode on a worker thread into raw bytes and build the pixbuf on the UI thread.
- **set -e and helper functions:** a function whose last test fails returns 1 and ends the script; end such helpers
  with `return 0`.
- **QEMU `sendkey` and the German layout:** the VM uses `kb_layout = "de"`, so QEMU's `z` arrives as `y` and the
  other way round (`sendkey ctrl-y` = Ctrl+Z). `mouse_move` is relative and drops quick successive moves; prefer
  keyboard tests.
- **RefCell in `if let`:** `if let Some(x) = cell.borrow().clone() { cell.replace(..) }` panics in edition 2021 –
  the borrow lives until the end of the `if let`. Bind the value first.
- **Application accelerators beat text fields:** `set_accels_for_action` fires before an entry sees the key, so file
  shortcuts (Ctrl+C/V/X, Delete) belong in a `ShortcutController` in the bubble phase instead.
- **GVfs trash listing lags:** a file trashed a moment ago may be missing from `trash:///`; read the `.trashinfo`
  files for undo (aco-files `trash.rs`).
