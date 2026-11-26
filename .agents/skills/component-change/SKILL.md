---
name: component-change
description: How to change a single ACO component (config repo) cleanly - theme-consistent, documented, tested. Use when editing anything under repos/aco-*.
---
# component-change
1. Read the component README and `docs/VISION.md`; find the theme tokens already used.
2. Branch (skill `git-workflow`), then edit only that repo.
3. Keep it slim: no new dependency/service without a reason; update the dependency list in `packaging`/PKGBUILD if needed.
4. Reuse theme values; do not add one-off colours/fonts.
5. Test: skill `vm-dev-loop` (sync, screenshot, check logs, check idle load).
6. Update README/docs in the same commit; Conventional Commit; bump submodule pointer.
Checklist: works in VM - matches theme - docs - no dead code - shellcheck clean.
