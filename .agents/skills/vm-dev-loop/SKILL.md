---
name: vm-dev-loop
description: Run, sync, inspect and reset the x86_64 Arch test VM to try desktop changes live. Use to test or visually verify any change.
---
# vm-dev-loop
All commands from `vm/`.
- Start (window): `open vm/gui.command` or `GUI=1 ./vm.sh run`. Headless: `./vm.sh run`. The VM is slow (TCG emulation): wait for `ssh` to answer.
- Push local changes: `./vm.sh sync hypr waybar` (none = all). Reloads Hyprland.
- Look: `./vm.sh shot` -> `vm/images/shot.png`; read the image to judge the result. The lock screen and the greeter
  cannot be captured with grim (it shows Hyprland's "lockscreen died" page instead): use `./vm.sh screendump`
  (QEMU monitor, `vm/images/screen.png`); unlock a test lock with `./vm.sh ssh 'pkill -USR1 hyprlock'`.
- Inspect: `./vm.sh ssh 'journalctl --user -b | tail'`, `ps aux --sort=-%mem | head`, `hyprctl ...` (set `XDG_RUNTIME_DIR=/run/user/1000`, `HYPRLAND_INSTANCE_SIGNATURE` from `/run/user/1000/hypr`).
- Discard: `./vm.sh reset`. The golden image is never modified by `run` (qcow2 overlay).
- Rebuild the golden image only at release (`base`, `provision`, `desktop`, `golden`).
Only one VM at a time (SSH port 2222). Stop with `./vm.sh stop`.
