---
name: autonomous-loop
description: The end-to-end self-driven development cycle for the ACO desktop (plan, branch, edit, sync to VM, verify by screenshot and logs, commit). Use when given a goal like "improve X" with little supervision.
---
# autonomous-loop
Work in this order; stop and ask the user only at the listed stop points.

1. **Orient**: read `AGENTS.md`, `docs/VISION.md`; `make branches`; `make status`.
2. **Plan**: write a short plan (goal, components touched, how to verify). Keep changes small.
3. **Branch** in each touched repo from `develop`: `feat/<topic>` (skill `git-workflow`).
4. **VM up**: `make vm-up` (headless, 3-6 min) if `make status` says stopped.
5. **Edit** in `repos/aco-<x>/` (skill `component-change`).
6. **Deploy**: `make sync C="<x>"`.
7. **Verify**: `make shot` and view `vm/images/shot.png`; `make logs` for errors; `vm/vm.sh ssh 'ps aux --sort=-%mem | head'` for idle load. Compare against VISION (theme consistency, slim).
8. **Iterate** 5-7 until the goal is met. If a change breaks the desktop: `make vm-reset && make vm-up`.
9. **Finish**: commit with Conventional Commits in the component repo, merge into `develop` (`--no-ff`), bump the submodule pointer in aco-dev, update docs (skill `clean-docs`). Leave a short summary of what changed and how it was verified.

## Stop points (ask the user)
- any push, GitHub change, tag, or merge to `main`
- adding a new package/service/dependency, or removing a component
- changing the theme tokens globally
- rebuilding the golden image or the signed registry (release)
- 3 failed attempts at the same problem
