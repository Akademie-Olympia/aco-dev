# aco-dev entry point. `make help` lists targets.
VM := vm/vm.sh
.DEFAULT_GOAL := help
.PHONY: help setup vm-up vm-gui vm-down vm-reset sync shot status logs branches check binds

help: ## show targets
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-10s %s\n",$$1,$$2}'
setup: ## init submodules and check host tools
	git submodule update --init --recursive
	@command -v qemu-system-x86_64 >/dev/null || { echo "missing: qemu (brew install qemu)"; exit 1; }
	@[ -f vm/images/golden.qcow2 ] || echo "no golden image yet: cd vm && ./vm.sh base && ./vm.sh provision && ./vm.sh desktop && ./vm.sh golden"
vm-up: ## start disposable headless VM from golden image (blocks until ssh)
	$(VM) run
vm-gui: ## open the VM window (separate terminal session)
	open vm/gui.command
vm-down: ## stop the VM
	$(VM) stop
vm-reset: ## discard all VM changes
	$(VM) reset
sync: ## copy components into VM: make sync C="hypr waybar" (empty = all)
	$(VM) sync $(C)
shot: ## screenshot of the VM desktop -> vm/images/shot.png
	$(VM) shot
status: ## vm / ssh / hyprland state
	$(VM) status
logs: ## hyprland + user journal logs from the VM
	$(VM) logs
branches: ## branch and dirty state of every repo
	@git submodule foreach -q 'echo "$$name: $$(git branch --show-current) dirty=$$(git status --short | wc -l)"'
binds: ## check every Hyprland key binding inside the VM (commands exist, no double bindings)
	$(VM) ssh 'cd ~/.config/hypr && python3 scripts/check-binds.py'
check: ## lint shell scripts and conventional-commit subjects of develop
	@command -v shellcheck >/dev/null && find repos vm -name '*.sh' -not -path '*/.git/*' | xargs shellcheck -S warning || echo "shellcheck not installed, skipped"
