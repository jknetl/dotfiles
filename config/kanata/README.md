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

### Fix: `tap-hold-release-tap-keys-release`

The HRM action used here resolves the hold/tap ambiguity by watching *which keys* were pressed and *how they were released*, not just timing:
- Same-hand non-HRM keys pressed → immediate tap (bilateral exclusion)
- Same-hand HRM keys: if released → tap; if held → hold (allows same-hand mod chords like Ctrl+Shift)
- Other-hand keys + release → hold (cross-hand mod combo)

## Timing Knobs

| Variable | Default | What it controls |
|---|---|---|
| `tap-time` | 200ms | Max time for a tap (release within this → letter) |
| `hold-time` | 250ms | Min time for a hold (held longer than this → modifier) |
| `hrm-idle-ms` | 150ms | Idle window before re-enabling HRMs after a letter tap |

**Tuning:**
- Still getting doubled letters? Raise `hrm-idle-ms`: 150 → 200 → 250
- Modifiers feel sluggish to engage during normal typing? Lower `hrm-idle-ms`
- Accidental mod fires (modifier triggers when you meant a letter)? Raise `hold-time`
- Taps feel unresponsive? Lower `tap-time`

Changes take effect after reloading kanata.

## Layers

| Layer | How to reach | Purpose |
|---|---|---|
| `qwerty` | default | Normal typing with HRMs |
| `nomods` | auto (while typing fast) | Same as qwerty but plain letters on home row |
| `navigation` | hold Space | Arrow keys (hjkl), F-keys on number row, reload (lrld) on R |
| `numeric` | hold ` (backtick/grv) | Numpad on right half, Del/Bksp on left |
| `training` | (comment out qwerty in config) | HRMs on, bottom-row mods disabled — builds muscle memory |

## Caps Word

Press **Space + Caps** (hold Space to enter the navigation layer, then tap Caps) to toggle Caps Word. While active, all letters are uppercase; it auto-disables at the next space, punctuation, or after 2 seconds of idle. Useful for typing `ALL_CAPS` identifiers without holding shift.

## Other Bindings

| Key | Tap | Hold |
|---|---|---|
| `caps` | Escape | Left Ctrl |
| `` ` `` (grv) | `` ` `` | Numeric layer |
| `Space` | Space | Navigation layer |

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
