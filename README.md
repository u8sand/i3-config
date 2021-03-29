# i3-config

My awesome i3 configuration.
Most things are tied into my directory tree but I've tried to utilize variables when possible (usually defined at the top as `$conf`).

To see how it works, you can just try it; you can also check out the [tutorial](TUTORIAL.md) and see if it is what you're looking for.

## Dependencies

Though there are many, many of these things you probably already have installed and don't really make sense without them (e.g. volume w/out alsa or battery w/out acpi)

- acpi (blocks/battery)
- alsa-utils (blocks/volume, mediakeys)
- dex (.desktop autostart integration)
- feh (random_wallpaper)
- i3 (naturally)
  - i3-gaps
  - i3blocks
  - i3lock
- jq (i3-msg json parsing)
- lm_sensors (blocks/temperature)
- picom (window opacity / shadow)
- playerctl (blocks/media_player, mediakeys)
- pwdx (context_aware_dir)
- python3 (i3-msg json parsing)
  - jsonpath (context_aware_dir)
  - i3ipc  (autoname_worspaces)
  - fontawesome (autoname_worspaces)
- rofi (shutdown_menu, run_menu)
- sysstat (blocks/cpu_usage)
- trash-cli (rm_wallpaper)
- xclip (sudo_paste)
- xf86-input-wacom (wacom)
- xfce4-settings (xfsettingsd)
- xfconf (cycle_mouse)
- xmacro (sudo_paste)
- xorg-xprop (autoname_worspaces)
- xss-lock (systemd lock integration)


### Quick Install

```bash
# maybe backup your existing directory
mv ~/.config/i3{,.sav}

# clone into i3 config directory
git clone https://github.com/u8sand/i3-config ~/.config/i3
cd ~/.config/i3

# replace yay with your AUR/pacman wrapper, or just use pacman filtering out the aur packages
yay -S - < arch.txt
pip3 install --user -r requirements.txt
```

## Credit where it is due

- `autoname_workspaces.py` was borrowed / modified and extended
- `/blocks` code I've borrowed / modified
- `compton.conf` was borrowed / modified
- `rofi.conf` was borrowed
- `wacom.sh` and `xsetwacom_my_preferences.sh` was borrowed / modified

The rest of the scripts, configuration, and bringing them all together were done over the years by myself.
Feel free to use any/all of my scripts as you see fit; the way I use it is: `git clone https://github.com/u8sand/i3-config ~/.config/i3` to ready my config. I may eventually extend this repository over time to address my entire arch setup; for now it's just i3.
