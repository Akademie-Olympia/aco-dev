# Theme

The single source of truth for colours, fonts and geometry is the `aco-theme` component (`repos/aco-theme`).
Components never hard-code these values: they ship templates in `aco-theme/*.tpl` that `aco-theme` renders to
`~/.config/aco/theme/<component>/`, and include the result. See `repos/aco-theme/README.md` for the mechanics.

## Look
Calm and modern, slightly macOS-inspired without copying it: one slim transparent top bar with workspace circles, a centred
Spotlight-like launcher, rounded windows with a soft shadow, a single accent colour, short settle-in animations.

## Choices (user-switchable)
| Choice | Values | Default |
| --- | --- | --- |
| theme | `aco` (graphite / paper) | `aco` |
| mode | `dark`, `light` | `dark` |
| accent | red orange yellow green cyan blue purple pink graphite, `#rrggbb` | `blue` |
| transparency | `on` (transparent bar, translucent launcher/terminals + blur), `off` | `on` |

## Palette `aco`
| Token | Dark | Light | Use |
| --- | --- | --- | --- |
| bg | `#161618` | `#f6f6f7` | window background |
| bg_alt | `#1c1c1f` | `#ececef` | bar, sidebars, headerbars |
| surface | `#232327` | `#ffffff` | views, menus, launcher, cards |
| surface_alt | `#2c2c31` | `#e4e4e8` | buttons, raised elements |
| border | `#38383e` | `#d2d2d8` | separators, outlines |
| muted | `#74747c` | `#8c8c94` | placeholders, inactive |
| subtext | `#a4a4ac` | `#55555d` | secondary text |
| text | `#e6e6ea` | `#1b1b1f` | primary text |
| red / orange / yellow / green | `#ef6461` `#f0955a` `#e8c468` `#6fcf8e` | `#d9423d` `#d4731f` `#b38600` `#2f9e58` | state, terminal |
| cyan / blue / purple / pink / graphite | `#5ccfd6` `#5b9cf6` `#a487f0` `#ec7fb6` `#9a9aa3` | `#138c96` `#2a6fdb` `#7d55d8` `#c94a8c` `#5f5f68` | accents, terminal |

## Fonts
- UI (bar, launcher, GTK, lock screen): **Adwaita Sans** 11, with **JetBrainsMonoNL Nerd Font Propo** as icon fallback.
- Terminals and editors: **JetBrainsMonoNL Nerd Font** 10.5. The NL variant has no ligatures, and kitty/Ghostty
  disable them explicitly, so `==`, `->` and `!=` always stay separate characters.

## Geometry
`radius` 10 (windows, menus, launcher), `radius_small` 6 (buttons, pills), `gaps_in` 4, `gaps_out` 8,
`border_width` 1, bar height 32, `opacity` 0.84 (surfaces), `term_opacity` 0.94, `bar_opacity` 0 (the bar floats over the wallpaper), blur size 8 / 2 passes.

## Terminal colours
The 16 ANSI colours come from the palette (light mode keeps "black" dark so it stays readable); colour 12 is the
accent. CLI tools should use palette colours (`fg=12`, `%F{8}`) instead of hex values, so they follow the theme live.

## Rules
- New colours go into the palette files, never into a component.
- Changing these defaults is a global theme change: ask the user first.
