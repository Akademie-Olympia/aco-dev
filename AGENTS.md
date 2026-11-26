# AGENTS.md – ACO development workspace

You are working in **aco-dev**, the umbrella repository for the ACO Arch Linux desktop.
Read first: [docs/VISION.md](docs/VISION.md), [docs/STRUCTURE.md](docs/STRUCTURE.md), [docs/CONVENTIONS.md](docs/CONVENTIONS.md).

## What this is
A slim, secure, modern, consistently themed Hyprland desktop on plain Arch. It is installed once on a base Arch and updated with `pacman -Syu`.
The configuration of each tool lives in its **own repository** (git submodule under `repos/`). This repo holds only the glue: vision, conventions, agent skills and the VM.

## Layout
- `repos/aco-*` – submodules, one per component plus `aco-arch-dotfiles` (installer, signed pacman registry, packaging) and `aco-docs`.
- `vm/` – x86_64 Arch test VM (`vm.sh`): base -> golden image -> disposable runs.
- `docs/` – cross-repo documentation.
- `.agents/skills/` – task playbooks; load the matching skill before doing that task.

## Hard rules
1. **Never commit to `main`** in any repo. Work on `develop` or `feat/<topic>`. `main` is touched only in the release step, by the user.
2. **Conventional Commits** in every repo (`feat(waybar): ...`). English, imperative, <= 72 chars subject.
3. **No pushes, no GitHub changes, no force-push** without explicit user approval.
4. Change a component only inside its own repo; then bump the submodule pointer here in a separate commit.
5. Test in the VM before calling something done (`vm/vm.sh sync <component>`, `vm/vm.sh shot`).
6. Clean code, no dead config, no commented-out leftovers, no unexplained magic values. Documentation in English, short and current.
7. Visual consistency: use the shared theme/palette/font defined in `docs/VISION.md`; never hard-code a one-off colour.
8. Do not put secrets, images or generated artefacts in git (`vm/images/` is ignored).

## Skills
`autonomous-loop` (start here for any goal), `git-workflow`, `component-change`, `vm-dev-loop`, `clean-docs`, `release-finalize` in `.agents/skills/<name>/SKILL.md`.

## Commands
```bash
git submodule update --init --recursive   # after cloning aco-dev
make help        # all targets
make setup | vm-up | sync C="hypr waybar" | shot | logs | status | branches | vm-reset
vm/vm.sh hypr <hyprctl args> | ssh <cmd>
```
