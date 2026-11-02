# Linux: restrict kanata to the laptop keyboard

Task for an agent running on the Linux laptop. Delete this file when done and update the "Device filtering" section in `README.md` and the matching bullet in `CLAUDE.md`.

## Goal

Kanata should remap only the laptop's built-in keyboard, so the systemd service can run all the time. When the docked ZMK keyboard is attached (it does home row mods in firmware), kanata must not grab it. No service stop or start when docking or undocking.

The macOS side is already done in `kanata-macos.kbd` with `macos-dev-names-include`. Linux uses the equivalent `linux-dev-names-include` in `kanata.kbd`.

## Steps

1. Find the built-in keyboard's device name.
   - Stop the service: `sudo systemctl stop kanata`.
   - Write a minimal config to `/tmp/kanata-min.kbd` (a `defsrc` with one key and a matching `deflayer`, no `linux-dev*` options, because any of them can hide devices).
   - Run `sudo kanata --cfg /tmp/kanata-min.kbd` and read the lines starting with `registering`. Note the quoted device names.
   - Pick the one that is the laptop's typing keyboard. Common values are `AT Translated Set 2 keyboard` or a vendor name. Ignore hotkey, WMI, power button, lid switch and webcam devices. `/proc/bus/input/devices` helps tell them apart (look for `EV=120013` and a `kbd` handler).
   - Run the check again with the ZMK keyboard docked, and confirm its name is different from the one you picked.
2. Edit `config/kanata/kanata.kbd`. Add to the existing `defcfg`:
   ```lisp
   (defcfg
     concurrent-tap-hold yes
     linux-dev-names-include (
       "<exact quoted name from step 1>"
     )
   )
   ```
   Kanata matches the full name exactly. No partial match and no regex. Do not touch anything else in the file.
3. Validate: `kanata --cfg ~/.config/kanata/kanata.kbd --check`.
4. Restart the service: `sudo systemctl restart kanata` (reload does not re-read the device list). Check `journalctl -u kanata -n 30` and confirm exactly one `registering` line, for the laptop keyboard.
5. Test:
   - Undocked: HRMs work on the laptop keyboard.
   - Docked: the ZMK keyboard types normally with no doubled modifiers or taps, and the service is still running.
   - Undock again: still works with no restart.
6. Update docs in `config/kanata/`:
   - `README.md`, "Device filtering" section: replace "not applied yet" with the real `linux-dev-names-include` line and how to list devices (the `registering` log lines).
   - `CLAUDE.md`, "Known intentional differences": drop "Linux is still pending".
   - Delete this file.
7. Commit only the kanata files. The working tree may contain unrelated uncommitted changes.

## Failure mode to know about

If the name is wrong, kanata finds no device and exits, so the keyboard is not remapped at all. The journal shows this right away. If the dotfiles are used on more than one Linux laptop, the name differs per machine. In that case tell the user and let them choose between a per-host override and a list of several names.
