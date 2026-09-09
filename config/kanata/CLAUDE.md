# CLAUDE.md — Kanata configs

`kanata.kbd` (Linux) and `kanata-macos.kbd` (macOS) implement the same keyboard
layout for two different physical bottom-row orders and modifier mappings
(macOS swaps Alt↔Meta; macOS `defsrc` also includes an `fn` key and a
duplicated F-row). Whenever you change a binding, alias, layer, chord, or
timing value in one file, make the equivalent change in the other — do not
edit only one and call the task done.

Known intentional differences to preserve (don't "fix" these into matching):
- `quick-hold-time`: 100ms on Linux, 120ms on macOS.
- Left-hand HRM hold keys: Linux is `A=lalt S=lmet`, macOS is `A=lmet S=lalt`
  (and mirrored on the right: `L`/`;`). This is the Alt↔Meta swap.
- `navlbr`/`scln` aliases hold to the opposite Alt/Meta key between the two
  files, for the same reason.
- macOS `defsrc`/layers have an extra `fn` column and a full F1–F12 row that
  Linux doesn't declare in `defsrc` (Linux reaches F-keys only via the
  navigation layer).

After editing, update `README.md` if the change affects layer behavior,
bindings tables, or timing knobs documented there.
