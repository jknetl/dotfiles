# Kanata Config

Kanata is a software keyboard remapper. These configs implement **Home Row Mods (HRM)** — the home-row letter keys double as modifier keys when held.

Two config files:
- `kanata.kbd` — Linux (bottom-left physical order: `lctl lmet lalt`)
- `kanata-macos.kbd` — macOS (bottom-left physical order: `lctl lalt lmet`)

## Home Row Mod Layout

```
Caps  A     S     D     F     G  |  H     J     K     L     ;     '
      Alt   Meta  Shift Ctrl     |        Ctrl  Shift Meta  Alt
```

macOS swaps Alt↔Meta on both sides (`A`=Cmd/Meta, `S`=Option/Alt, `L`=Option/Alt, `;`=Cmd/Meta).

Tap = letter. Hold = modifier. The modifiers are **bilateral**: holding `F` (left Ctrl) and pressing `J` (right Ctrl) works normally; the bilateral-key lists prevent same-hand accidental modifier activation.

## Why This Structure

### The doubling problem

OS auto-repeat and kanata's tap-hold resolution can collide: if you're still physically releasing a home-row key when auto-repeat fires the next keypress, you get a doubled letter (`the` → `thee`). This is the most common HRM complaint.

### Fix: fast-typing exclusion (`nomods` layer)

While you're typing letters, kanata automatically switches to the `nomods` layer — an identical copy of `qwerty` with the eight HRM aliases replaced by plain letters. After `hrm-idle-ms` milliseconds of idle, it switches back to `qwerty` (with HRMs enabled). This is kanata's equivalent of ZMK's `require-prior-idle-ms` / QMK's Flow Tap.

The mechanism: every HRM tap action includes `@tap`, which triggers the layer switch + idle return via `on-idle-fakekey`.

`nomods` keeps `@spc-arr` and `@f13` live, so the symbol and navigation layers stay reachable mid-burst. Only the eight home-row modifiers are suppressed. (Replace them with plain `spc` / `f13` if you also get accidental layer activations from lingering on space.)

**This mechanism breaks silently if the `nomods` layer is missing** — `@tap` then becomes `(layer-switch qwerty)` from `qwerty`, a no-op, and the config still passes `--check`. If accidental modifiers suddenly get worse, check that `deflayer nomods` exists and that `tap` switches to it.

### Fix: `tap-hold-release-tap-keys-release`

The HRM action used here resolves the hold/tap ambiguity by watching *which keys* were pressed and *how they were released*, not just timing. Signature:

```
(tap-hold-release-tap-keys-release $repress-time $hold-time $tap $hold
                                  $tap-trigger-keys-on-press
                                  $tap-trigger-keys-on-press-then-release)
```

- Same-hand non-HRM keys (`$*-hand-press`) pressed → immediate tap (bilateral exclusion)
- Same-hand HRM keys (`$*-hand-release`): if released → tap; if held → hold (allows same-hand mod chords like Ctrl+Shift)
- Other-hand keys → no early tap; resolved by `hold-time` alone. This is the case `nomods` covers.

## Timing Knobs

| Variable | Current | What it controls |
|---|---|---|
| `repress-time` | 200ms | Max time for a tap (release within this → letter) |
| `hold-time` | 200ms | Min time for a hold (held longer than this → modifier) |
| `quick-hold-time` | 100ms (Linux) / 120ms (macOS) | Hold time for `` ` `` → symbol layer |
| `hrm-idle-ms` | 90ms | Idle window before re-enabling HRMs after a letter tap |
| `chord-time` | 80ms | Max spread for a `defchordsv2` chord |

**Tuning:**
- Still getting doubled letters? Raise `hrm-idle-ms`: 90 → 150 → 200
- Modifiers feel sluggish to engage during normal typing? Lower `hrm-idle-ms`
- Accidental mod fires (modifier triggers when you meant a letter)? Raise `hold-time`
- Taps feel unresponsive? Lower `repress-time`

Changes take effect after reloading kanata.

## Layers

| Layer | How to reach | Purpose |
|---|---|---|
| `qwerty` | default | Normal typing with HRMs |
| `nomods` | auto (while typing fast) | Same as qwerty but plain letters on home row |
| `navigation` | hold right Space (`f13`), hold right Cmd / right Alt, or hold Caps | Arrows on hjkl, F-keys on number row, `up` on W, reload (`lrld`) on R, caps-word on Caps |
| `symbol` | hold left Space, or hold `` ` `` | Numpad on right half, `Del`/`Bksp` on left, `=` on G, `-` on P, `` ` `` on Tab, `!@#$%` on QWERT, `^&*-` on ASDF (no HRM on this layer's left hand) |

## Caps Word

Hold **right Space** (to enter the navigation layer), then tap **Caps**. While active, all letters are uppercase; it auto-disables at the next space, punctuation, or after 2 seconds of idle. Useful for typing `ALL_CAPS` identifiers without holding shift.

## Other Bindings

| Key | Tap | Hold |
|---|---|---|
| `caps` | Escape | Navigation layer |
| `` ` `` (grv) | `` ` `` | Symbol layer (`quick-hold-time`) |
| left `Space` | Space | Symbol layer |
| right `Space` (`f13`) | Enter | Navigation layer |
| right Cmd (macOS `rmet`) / right Alt (Linux `ralt`) | Enter | Navigation layer |
| `'` | `'` | Right Ctrl |
| `[` (symbol layer) | Del | Right Alt (macOS) / Right Meta (Linux) |
| `tab` (symbol layer) | `` ` `` | — |

The `[` key on the qwerty layer is remapped to `Bksp`.

## Chords

Active only on the `navigation` and `symbol` layers, within `chord-time`, released together:

| Chord | Output |
|---|---|
| `r`+`t` | `(` |
| `y`+`u` | `)` |
| `f`+`g` | `[` |
| `h`+`j` | `]` |
| `v`+`b` | `{` |
| `n`+`m` | `}` |
| `m`+`,` | Escape |
| `,`+`.` | Enter |

## Reload

Linux (systemd):
```bash
sudo systemctl reload kanata
```

macOS (launchd or manual):
```bash
# If running as a service — check your launchd plist
launchctl stop com.example.kanata && launchctl start com.example.kanata

# Or just kill and restart manually
pkill kanata && kanata --cfg ~/.config/kanata/kanata-macos.kbd &
```

Syntax check without reloading:
```bash
kanata --cfg ~/.config/kanata/kanata.kbd --check
```
