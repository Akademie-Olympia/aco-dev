# aco-vm
x86_64 Arch VM (QEMU, emulated) to develop/test the ACO dotfiles with an AI agent.
1. `./vm.sh base` – download Arch cloud image, create user `aco`, boot
2. `./vm.sh provision` – run ACO installer inside
3. `./vm.sh golden` – save as golden image
4. `./vm.sh run` (`GUI=1` for window) – disposable overlay; `./vm.sh ssh cmd` for the agent; `./vm.sh reset` to discard

## Dev loop
- `open gui.command` (or `GUI=1 ./vm.sh run`) – start fresh desktop from golden
- edit `../repos/aco-<component>/` on the Mac, then `./vm.sh sync hypr waybar` (no args = all) – copies into `~/.config` in the VM and reloads Hyprland
- `./vm.sh shot` – screenshot of the VM desktop (for the agent), `./vm.sh ssh cmd` – run commands
- `./vm.sh reset` – throw away all VM changes
- To bake accepted changes into a new base: push component repos, `./vm.sh start`, update, `./vm.sh golden`
