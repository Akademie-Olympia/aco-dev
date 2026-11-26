# Enabling an agent to work autonomously

## One-time host setup
```bash
brew install qemu shellcheck gh git
gh auth login
git clone --recurse-submodules https://github.com/Akademie-Olympia/aco-dev && cd aco-dev
make setup
# build the golden image once (about 30-60 min under emulation):
cd vm && ./vm.sh base && ./vm.sh provision && ./vm.sh desktop && ./vm.sh golden
```
The images live in `vm/images/` (about 4 GB, not in git). Copy them to a second Mac instead of rebuilding.

## Start the agent
1. Open the agent **in the `aco-dev` root** (the workspace). It then finds `AGENTS.md` and `.agents/skills/` automatically.
2. Give it a goal in one sentence, e.g.:
   > Use the autonomous-loop skill. Goal: make Waybar consistent with the Hyprland theme and verify in the VM.
3. Watch the window with `make vm-gui` if you want to see what it does.

## Permissions to grant (so it does not ask constantly)
Allow without confirmation: file edits inside `aco-dev`, `git` on local branches (add/commit/checkout/merge/branch), `make *`, `vm/vm.sh *`, `ssh` to `127.0.0.1:2222`, `qemu-*`, `shellcheck`.
Keep on confirmation: `git push`, `gh *`, `git tag`, anything on `main`, `rm -rf` outside `vm/images`, installing host software.
Set this in your agent's permission/allow-list settings (for Antigravity: the command allow-list in settings or in the workspace rules).

## Guardrails already built in
- The VM runs on a throw-away overlay; `make vm-reset` always returns to the golden image.
- `AGENTS.md` forbids commits on `main`, pushes and new dependencies without approval; stop points are listed in the `autonomous-loop` skill.
- Verification is concrete: screenshot + logs + idle-load check, not just "it looks fine".

## Tips
- Long autonomous runs: use the agent's `/goal` mode with the goal sentence above.
- Several independent components in parallel: one sub-agent per component repo, each on its own `feat/` branch; only one VM at a time (port 2222), so sync and verify sequentially.
- Release is manual: ask for the `release-finalize` skill when you are happy.
