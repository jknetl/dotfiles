# CLAUDE.md — Kanata configs

`kanata.kbd` (Linux) and `kanata-macos.kbd` (macOS) implement the same keyboard
layout for two different physical bottom-row orders and modifier mappings
(macOS swaps Alt↔Meta; macOS `defsrc` also includes an `fn` key and a
duplicated F-row). Whenever you change a binding, alias, layer, chord, or
timing value in one file, make the equivalent change in the other — do not
edit only one and call the task done.

Known intentional differences to preserve (don't "fix" these into matching):
- `quick-hold-time`: 100ms on Linux, 120ms on macOS.
- HRM hold keys: Linux is `A=lalt S=lmet D=lctl F=lsft` (mirrored on the right:
  `J=rsft K=rctl L=rmet ;=ralt`), macOS is `A=lctl S=lalt D=lmet F=lsft`
  (`J=rsft K=rmet L=ralt ;=rctl`). This applies to the `nav-*` and `sym-*`
  aliases too.
- `navlbr`/`scln` aliases hold to the opposite Alt/Meta key between the two
  files, for the same reason.
- macOS `defsrc`/layers have an extra `fn` column and a full F1–F12 row that
  Linux doesn't declare in `defsrc` (Linux reaches F-keys only via the
  navigation layer).

After editing, update `README.md` if the change affects layer behavior,
bindings tables, or timing knobs documented there.
