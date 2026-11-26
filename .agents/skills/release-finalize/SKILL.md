---
name: release-finalize
description: Produce the final clean state of all repos at the end of development (merge to main, tag, rebuild golden image). Use only when the user asks to release.
---
# release-finalize
Only on explicit user request.
1. Every repo: clean tree, `develop` green in the VM, docs current, history readable (squash/fixup *feature* branches before merging, never rewrite published history).
2. Merge `develop` -> `main` (`--no-ff` or fast-forward), tag `vX.Y.Z` per repo.
3. `aco-arch-dotfiles`: update packages, build, sign and publish the registry (key fingerprint stays pinned in the installer).
4. Rebuild VM: `vm.sh base && provision && desktop && golden`; verify the desktop end to end with a fresh `run`.
5. Update aco-dev submodule pointers to the tags; tag aco-dev.
6. Ask the user before every push.
