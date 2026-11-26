#!/usr/bin/env bash
# ACO VM: x86_64 Arch (QEMU TCG) -> base -> provision -> golden -> disposable runs
set -euo pipefail
cd "$(dirname "$0")"
D=images; mkdir -p $D
URL=https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
SIZE=${SIZE:-30G}; MEM=${MEM:-6G}; CPUS=${CPUS:-4}; PORT=${PORT:-2222}
SSH_OPTS=(-p $PORT -i $D/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=15)
DAEMON=(-daemonize); DISPLAY_OPT=(-display none); [ "${GUI:-0}" = 1 ] && { DISPLAY_OPT=(-display cocoa); DAEMON=(); }
qemu_run() { # $1 disk
  qemu-system-x86_64 -machine q35 -cpu max -accel tcg,thread=multi -smp $CPUS -m $MEM \
    -drive file="$1",if=virtio -device virtio-vga -device qemu-xhci -device usb-kbd -device usb-tablet \
    -nic user,hostfwd=tcp::$PORT-:22 "${DISPLAY_OPT[@]}" -serial file:$D/serial.log "${DAEMON[@]}" -pidfile $D/qemu.pid
}
ssh_vm() { ssh "${SSH_OPTS[@]}" aco@127.0.0.1 "$@"; }
wait_ssh() { echo "waiting for ssh (slow under emulation)..."; until ssh_vm true 2>/dev/null; do sleep 10; done; }
stop() { [ -f $D/qemu.pid ] && kill "$(cat $D/qemu.pid)" 2>/dev/null || true; rm -f $D/qemu.pid; }
case "${1:-help}" in
  base)  # download + cloud-init seed, first boot
    [ -f $D/arch-orig.qcow2 ] || { curl -fL -o $D/arch-orig.qcow2.part $URL && mv $D/arch-orig.qcow2.part $D/arch-orig.qcow2; }
    [ -f $D/id_ed25519 ] || ssh-keygen -q -t ed25519 -N '' -f $D/id_ed25519
    cp $D/arch-orig.qcow2 $D/base.qcow2; qemu-img resize $D/base.qcow2 $SIZE
    mkdir -p $D/seed; PUB=$(cat $D/id_ed25519.pub)
    printf 'instance-id: aco\nlocal-hostname: aco\n' > $D/seed/meta-data
    cat > $D/seed/user-data <<UD
#cloud-config
users:
  - name: aco
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: aco
    ssh_authorized_keys: [$PUB]
growpart: {mode: auto, devices: ['/']}
ssh_pwauth: true
UD
    rm -f $D/seed.iso; hdiutil makehybrid -quiet -iso -joliet -default-volume-name cidata -o $D/seed.iso $D/seed
    qemu-system-x86_64 -machine q35 -cpu max -accel tcg,thread=multi -smp $CPUS -m $MEM \
      -drive file=$D/base.qcow2,if=virtio -drive file=$D/seed.iso,media=cdrom,readonly=on \
      -nic user,hostfwd=tcp::$PORT-:22 -display none -serial file:$D/serial.log -daemonize -pidfile $D/qemu.pid
    wait_ssh; echo "base ready (user aco / pw aco, key $D/id_ed25519)";;
  provision) # run ACO installer inside running base VM
    ssh_vm "sudo pacman -Syu --noconfirm && sudo pacman -S --needed --noconfirm git curl base-devel"
    if [ -n "${LOCAL:-}" ]; then ssh_vm "curl -fsSL https://raw.githubusercontent.com/Akademie-Olympia/aco-arch-dotfiles/main/install.sh | bash -s -- --yes" ; else
      ssh_vm "curl -fsSL https://raw.githubusercontent.com/Akademie-Olympia/aco-arch-dotfiles/main/install.sh | bash -s -- --yes"; fi;;
  desktop) # autologin on tty1 + start Hyprland (software rendering for the VM)
    ssh_vm 'sudo mkdir -p /etc/systemd/system/getty@tty1.service.d && printf "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin aco --noclear %%I \$TERM\n" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null
      cat > ~/.bash_profile <<EOP
[ -f ~/.bashrc ] && . ~/.bashrc
if [ -z "\$WAYLAND_DISPLAY" ] && [ "\$(tty)" = /dev/tty1 ]; then
  export WLR_RENDERER_ALLOW_SOFTWARE=1 WLR_NO_HARDWARE_CURSORS=1 AQ_NO_MODIFIERS=1
  exec Hyprland
fi
EOP';;
  golden) ssh_vm "sudo poweroff" || true; sleep 15; stop; cp $D/base.qcow2 $D/golden.qcow2; echo "golden saved";;
  run)    # disposable overlay on golden; GUI=1 for window
    rm -f $D/run.qcow2; qemu-img create -q -f qcow2 -F qcow2 -b golden.qcow2 $D/run.qcow2
    if [ "${GUI:-0}" = 1 ]; then qemu_run "$D/run.qcow2"; else qemu_run "$D/run.qcow2"; wait_ssh; fi; echo "ssh: ./vm.sh ssh";;
  start)  qemu_run "$D/base.qcow2"; wait_ssh;;
  sync)   # copy local component repos (../aco-*) into ~/.config in the VM; usage: sync [hypr waybar ...]
    shift; MAP="foot:foot fuzzel:fuzzel ghostty:ghostty gtk3:gtk-3.0 gtk4:gtk-4.0 hypr:hypr kitty:kitty libfm:libfm nvim:nvim pcmanfm:pcmanfm tmux:tmux vim:vim waybar:waybar yazi:yazi zsh:zsh"
    for e in $MAP; do r=${e%%:*}; t=${e##*:}
      if [ $# -gt 0 ] && [[ " $* " != *" $r "* ]]; then continue; fi
      [ -d ../repos/aco-$r ] || continue
      echo "sync aco-$r -> ~/.config/$t"
      COPYFILE_DISABLE=1 tar --no-xattrs -C ../repos/aco-$r --exclude=.git -cf - . | ssh_vm "mkdir -p ~/.config/$t && tar --warning=no-unknown-keyword -C ~/.config/$t -xf -"
    done; ssh_vm 'pgrep -x Hyprland >/dev/null && hyprctl reload >/dev/null 2>&1; true';;
  shot)   # screenshot of the VM desktop to images/shot.png
    ssh_vm 'XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-1 grim - 2>/dev/null || (sudo pacman -S --noconfirm grim >/dev/null && XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-1 grim -)' > $D/shot.png; echo $D/shot.png;;
  status) if [ -f $D/qemu.pid ] && kill -0 "$(cat $D/qemu.pid)" 2>/dev/null; then echo "vm: running"; else echo "vm: stopped"; exit 0; fi
    ssh_vm true 2>/dev/null && echo "ssh: ok" || { echo "ssh: not ready (still booting?)"; exit 0; }
    ssh_vm 'pgrep -x Hyprland >/dev/null && echo "hyprland: running" || echo "hyprland: not running"';;
  hypr)   shift; ssh_vm "export XDG_RUNTIME_DIR=/run/user/1000; export HYPRLAND_INSTANCE_SIGNATURE=\$(ls -t /run/user/1000/hypr | head -1); hyprctl $*";;
  logs)   ssh_vm 'export XDG_RUNTIME_DIR=/run/user/1000; sig=$(ls -t /run/user/1000/hypr | head -1); tail -n ${N:-60} /run/user/1000/hypr/$sig/hyprland.log; echo ---; journalctl --user -b --no-pager -n 30';;
  ssh)    shift; ssh_vm "$@";;
  stop)   stop;;
  reset)  stop; rm -f $D/run.qcow2;;
  *) echo "usage: vm.sh base|provision|desktop|golden|run|sync|shot|status|hypr|logs|ssh|stop|reset   (GUI=1 for window)";;
esac
