# Kanata Config

Kanata is a software keyboard remapper. These configs implement **Home Row Mods (HRM)** — the home-row letter keys double as modifier keys when held.

The HRM behavior is modeled on the ZMK keymap of the docked MoErgo Go60, kept in this repo at [`../zmk/go60/zmk_mylayout_5.4.keymap`](../zmk/go60/zmk_mylayout_5.4.keymap). It is the reference for the per-finger timings; if you retune the HRMs there, mirror the change here.

Two config files:
- `kanata.kbd` — Linux (bottom-left physical order: `lctl lmet lalt`)
- `kanata-macos.kbd` — macOS (bottom-left physical order: `lctl lalt lmet`)

## Home Row Mod Layout

```
Caps  A     S     D     F     G  |  H     J     K     L     ;     '
      Alt   Meta  Ctrl  Shift    |        Shift Ctrl  Meta  Alt
```

(Layout above is Linux.) macOS swaps Alt↔Meta on both sides (`A`=Cmd/Meta, `S`=Option/Alt, `L`=Option/Alt, `;`=Cmd/Meta), and keeps the old `Shift Ctrl` / `Ctrl Shift` order on `D F` / `J K`.
This is the Linux/Windows layout (`kanata.kbd`). `kanata-macos.kbd` still has Shift on the middle fingers (`D`/`K`) and Ctrl on the index fingers (`F`/`J`).

macOS swaps Alt↔Meta on both sides (`A`=Cmd/Meta, `S`=Option/Alt, `L`=Option/Alt, `;`=Cmd/Meta).
`kanata-macos.kbd` uses a different order, Ctrl Option Cmd Shift from left to right on the left hand, mirrored on the right:

```
Caps  A     S     D     F     G  |  H     J     K     L     ;     '
      Ctrl  Opt   Cmd   Shift    |        Shift Cmd   Opt   Ctrl
```

Tap = letter. Hold = modifier. The HRM behavior is modeled on the ZMK keymap in `zmk_mylayout_5.4.keymap` (Go60), so the laptop feels like the docked keyboard.

**Requires kanata >= 1.12.0** (`defhands`, `tap-hold-opposite-hand-release`, `require-prior-idle`). Check with `kanata --version`.

## How the HRMs resolve

Each home-row key is `tap-hold-opposite-hand-release`, the equivalent of ZMK's `tap-preferred` hold-tap with `hold-trigger-key-positions` + `hold-trigger-on-release`:

| Situation | Result | ZMK equivalent |
|---|---|---|
| A key from the **opposite hand** is pressed *and released* while the HRM key is held | modifier | `hold-trigger-key-positions` + `hold-trigger-on-release` |
| A key from the **same hand** is pressed | letter | positional hold-tap (same-hand keys not in the trigger list) |
| A thumb key (`spc`, `f13`) is pressed and released | modifier | thumb positions in the trigger list |
| Held past the per-finger tapping term with nothing else | modifier | `tap-preferred` timeout |
| Pressed within `idle-*` ms after any other key | letter immediately | `require-prior-idle-ms` |
| Tapped, then pressed again within `quick-tap` ms | letter again (key repeat works) | `quick-tap-ms` |

Hand assignment comes from the `defhands` block (whole keyboard, not just letters). Consequence, same as on ZMK: same-hand modifier chords (e.g. holding `A` + `F` on the left hand) are not possible; use one key from each hand.

The old `nomods` helper layer and the `@tap` / `on-idle-fakekey` machinery were removed: `require-prior-idle` does the same job natively and per finger. The `sym-*` aliases use the same mechanism.

## Timing Knobs

Per-finger values are copied from the ZMK behaviors (`HRM_*_v1_TKZ`):

| Variable | Current | What it controls |
|---|---|---|
| `tt-index` | 190ms | Tapping term for `F` / `J` (hold after this with no other key) |
| `tt-middy` / `tt-ring` | 210ms | Tapping term for `D` `K` / `S` `L` |
| `tt-pinky` | 260ms | Tapping term for `A` / `;` |
| `idle-index` | 100ms | Index keys: typed this soon after another key → always a letter |
| `idle-other` | 150ms | Same for middle/ring/pinky |
| `quick-tap` | 300ms | Re-press window after a tap → letter again / key repeat |
| `repress-time`, `hold-time` | 200ms | Non-HRM tap-holds (Tab, Space, Caps, `'`, …) |
| `quick-hold-time` | 100ms (Linux) / 120ms (macOS) | Hold time for `` ` `` → symbol layer |
| `chord-time` | 80ms | Max spread for a `defchordsv2` chord |

## Adjusting the HRMs

### Workflow

1. Edit the values in the `defvar` block at the top of **both** `kanata.kbd` and `kanata-macos.kbd` (keep them in sync, see `CLAUDE.md`).
2. Validate: `kanata --cfg kanata.kbd --check` (and `kanata-macos.kbd`).
3. Reload (see [Reload](#reload)) and type for a while. Change **one knob at a time**, by small steps (10-20ms for `tt-*`, 25-50ms for `idle-*`).

### Symptom → knob

| Symptom | Cause | Fix |
|---|---|---|
| Modifier fires while typing a word fast (e.g. `as` gives Alt+s) | HRM key pressed too soon after another key, or rolled over with an opposite-hand key | Raise `idle-other` (150 → 200) or `idle-index` (100 → 150) |
| Same, but only for one finger | That finger's tapping term is too short | Raise that finger's `tt-*` |
| Modifier doesn't fire when held on purpose | Tapping term too long, or `idle-*` too high so quick shortcuts count as typing | Lower that finger's `tt-*`, or lower `idle-*` |
| Shortcut like `Ctrl+C` right after typing gives a letter instead | `idle-*` window still open | Lower `idle-*`, or pause briefly before the shortcut |
| Holding a home-row key for key repeat gives a modifier | Re-press after a tap is outside `quick-tap` | Raise `quick-tap` |
| Doubled letters (`the` → `thee`) | `quick-tap` too long, so a legitimate second tap is treated as a repeat | Lower `quick-tap` |
| Tab / Space / Caps / `'` feel unresponsive or misfire | These are plain tap-holds, not HRMs | Tune `repress-time` / `hold-time` |
| Same-hand chord (e.g. `A`+`F`) never gives both modifiers | By design, same-hand keys always resolve as a tap (same as ZMK) | Use one key from each hand, or set `(same-hand hold)` on the alias |

### Which knob does what

- **`tt-*` (tapping term):** how long a key must be held, with no other key involved, before it becomes a modifier. Longer is safer against false activation but slower to hold.
- **`idle-*` (require-prior-idle):** if any key was pressed less than this many ms before, the HRM key is a letter immediately. This is the main defence against false activation during fast typing. Index fingers get a shorter window because they hold modifiers most often.
- **`quick-tap`:** after a tap, pressing the same key again within this window is always a letter, which makes key repeat work.

### Per-key and structural tweaks

These are edited in the HRM `defalias` blocks (`a s d f j k l ;`, plus `sym-j/k/l/scln`), which all share the same option list:

```
(tap-hold-opposite-hand-release $tt-pinky a lalt
  (timeout hold) (same-hand tap) (neutral-keys spc f13) (neutral hold)
  (require-prior-idle $idle-other) (tap-repress-timeout $quick-tap))
```

| Option | Effect of changing it |
|---|---|
| `(timeout hold)` → `(timeout tap)` | Holding without pressing another key outputs the letter instead of the modifier. Only opposite-hand keys can then trigger the modifier. |
| `(same-hand tap)` → `(same-hand hold)` / `ignore` | `hold` makes a same-hand key trigger the modifier (allows same-hand chords, more false activations). `ignore` waits for the timeout instead of deciding. |
| `(neutral hold)` → `(neutral tap)` | `spc` / `f13` stop triggering the modifier, so `Space` after a home-row key is always a letter first. Useful if `a`+`Space` gives Alt+Space by accident. |
| `tap-hold-opposite-hand-release` → `tap-hold-opposite-hand` | Decide on the opposite key's **press** instead of press+release: faster modifiers, more false activations on rolls. |
| `defhands` | Add or move keys between hands. A key missing from both lists is treated as unknown and ignored. |

Per-key values can also be overridden in the alias itself, e.g. `(require-prior-idle 200)` for a single key instead of a shared variable.

Changes take effect after reloading kanata.

## Layers

| Layer | How to reach | Purpose |
|---|---|---|
| `qwerty` | default | Normal typing with HRMs |
| `navigation` | hold Space, hold right Space (`f13`), hold right Cmd (`rmet`), or hold Tab | Arrows on hjkl, F-keys on number row, `up` on W, reload (`lrld`) on R, caps-word on Caps |
| `symbol` | hold `` ` ``, or hold right Alt | Modeled on the ZMK `symbol` layer. Numpad on right half; `F1`–`F7` `/ * + Del` on the number row; `!@#$%` on QWERT; `^&*()` on ASDFG; `` ` - = [ ] `` on ZXCVB; `-` on P; `` ` `` on Tab |

On `navigation` the right-hand home row (`j k l ;`) is plain keys, and on `symbol` the left-hand home row (`a s d f`) is plain keys. The opposite hand keeps HRM behavior there: on `navigation` `a s d f` and on `symbol` `j k l ;` tap the layer's own action (arrow, digit, symbol) and hold the same modifier as on `qwerty` (`sym-j/k/l/scln` aliases on `symbol`). This means the hold works regardless of whether you press the layer-switch key or the home-row key first.

## Caps Word

Hold **right Space** or **Tab** (to enter the navigation layer), then tap **Caps**. While active, all letters are uppercase; it auto-disables at the next space, punctuation, or after 2 seconds of idle. Useful for typing `ALL_CAPS` identifiers without holding shift.

## Other Bindings

| Key | Tap | Hold |
|---|---|---|
| `caps` | Escape | Left Ctrl |
| `tab` | Tab | Navigation layer |
| `` ` `` (grv) | `` ` `` | Symbol layer (`quick-hold-time`) |
| left `Space` | Space | Navigation layer |
| right `Space` (`f13`) | Enter | Navigation layer |
| right Cmd (`rmet`) | Enter | Navigation layer |
| right Alt (`ralt`) | Enter | Symbol layer |
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
| `x`+`c` | `-` |

## Device filtering

Kanata only grabs the laptop's built-in keyboard, so the service can stay running while a docked ZMK keyboard (which does home row mods in firmware) is attached. Without the filter, kanata would remap the ZMK keyboard a second time.

- macOS: `macos-dev-names-include ("Apple Internal Keyboard / Trackpad")` in `kanata-macos.kbd`. List devices with `kanata --list`.
- Linux: `linux-dev-names-include ("AT Translated Set 2 keyboard")` in `kanata.kbd`. List devices by running kanata without a filter and reading the `is included`/`is ignored` journal lines, or with `grep Name /proc/bus/input/devices`. The name is machine-specific.

If the built-in keyboard is ever replaced or the name changes, kanata finds no device to grab and stops remapping. Re-run the device listing and update the name.

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
