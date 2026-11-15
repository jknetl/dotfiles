# udev rules

System-wide udev rules. Not linked by `./install`. Copy them into `/etc/udev/rules.d/` by hand (needs root).

| File | What it does |
|---|---|
| `90-backlight.rules` | Lets the `video` group write the screen brightness (`/sys/class/backlight/*/brightness`), so the user can change it without sudo. Add yourself to `video`. |
| `90-wakeup-allowlist.rules` | Only the lid and the power button can wake the laptop from suspend. Turns wake off for USB, Thunderbolt, PCIe ports, LAN, touchpad, built-in keyboard and sleep button, so a mouse moved by table vibration doesn't wake it. **Hardware-specific: written for HP ZBook Power 15.6" G9** — the PCI/i2c addresses (e.g. `0000:00:14.0`, `i2c-ELAN0774:00`) will differ elsewhere. Check them on other hardware (`cat /proc/acpi/wakeup`). |

## Install

```bash
sudo install -m 644 system/udev/rules.d/*.rules /etc/udev/rules.d/
sudo udevadm control --reload && sudo udevadm trigger
```

## Verify

```bash
# backlight: group should be video, group-writable
ls -l /sys/class/backlight/*/brightness

# wakeup: only lid, power button, battery, RTC and GPIO should be listed
for f in /sys/bus/*/devices/*/power/wakeup; do [ "$(cat $f)" = enabled ] && echo "$f"; done
```
