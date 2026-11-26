# Conventions

## Branches (all repos)
- `main` – released, always clean. Only changed at release time.
- `develop` – integration branch; default working branch of the submodules.
- `feat/<topic>`, `fix/<topic>`, `docs/<topic>`, `refactor/<topic>`, `chore/<topic>` – lowercase kebab-case, short, from `develop`.

## Commits – Conventional Commits
`<type>(<scope>): <subject>` with types `feat fix docs style refactor perf test build ci chore revert`.
Scope = component (`waybar`, `hypr`, `installer`, `vm`). Subject imperative, lowercase, no trailing dot, <= 72 chars. Body explains *why*. Breaking change: `!` and a `BREAKING CHANGE:` footer. One logical change per commit.

## Naming
- Repos: `aco-<component>`; component = upstream tool name (gtk3/gtk4 without dash).
- Files/dirs: lowercase kebab-case; shell scripts `name.sh`, executable, `#!/usr/bin/env bash`, `set -euo pipefail`.
- Shell/Lua/CSS identifiers: snake_case (shell, Lua), kebab-case (CSS classes). Env vars `ACO_*`.
- Packages: `aco-arch-dotfiles-<component>`.

## Code
Small, single-purpose files; no duplication across components (shared values come from the theme); comments explain why; no dead code; scripts pass `shellcheck`; Lua configs formatted with `stylua` where used.

## Docs
English, short, current. Each repo: README (what, install, config, dependencies) and, if needed, a CHANGELOG. Long docs go to `aco-docs`. Update docs in the same commit as behaviour.

## Versions/Release
Semantic versioning per component; the final clean state of each repo is tagged only at release.
