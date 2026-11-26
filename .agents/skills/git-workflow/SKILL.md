---
name: git-workflow
description: Branching, Conventional Commits and submodule handling across the aco-dev repos. Use for any commit, branch, merge or submodule-pointer update.
---
# git-workflow
1. Check the branch: `git -C repos/aco-<x> branch --show-current`. If `main`, switch: `git checkout develop`.
2. New topic: `git checkout -b feat/<kebab-topic> develop`.
3. Commit small and logical: `git commit -m "feat(waybar): add battery module"`. Types/scopes: docs/CONVENTIONS.md.
4. Merge into `develop` with `--no-ff` once tested in the VM.
5. In aco-dev: `git add repos/aco-<x> && git commit -m "chore(submodule): bump aco-<x> to <short-sha>"`.
6. Overview: `git submodule foreach 'echo $name: $(git branch --show-current) $(git status --short | wc -l)'`.
Never touch `main`, never push or force-push without user approval.
