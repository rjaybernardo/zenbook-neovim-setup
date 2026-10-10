#!/usr/bin/env bash
# Install the "zenbook" SDDM theme and make it the active login screen.
# Usage: sudo ./install.sh [wallpaper]   (defaults to the Noctalia wallpaper)
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)/zenbook"
dest=/usr/share/sddm/themes/zenbook
user_home=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)
wallpaper="${1:-$user_home/Pictures/uwp5093073.png}"

[[ $EUID -eq 0 ]] || { echo "Run with sudo." >&2; exit 1; }
[[ -f $wallpaper ]] || { echo "Wallpaper not found: $wallpaper" >&2; exit 1; }

rm -rf "$dest"
cp -r "$src" "$dest"
# SDDM can't read your home folder, so the wallpaper is copied (and shrunk) into the theme.
magick "$wallpaper" -resize 2560x1440^ -quality 90 "$dest/background.jpg"
chmod -R a+rX "$dest"

# /etc/sddm.conf overrides /etc/sddm.conf.d, so set the theme there.
conf=/etc/sddm.conf
touch "$conf"
[[ -f $conf.bak ]] || cp "$conf" "$conf.bak"
if grep -q '^\[Theme\]' "$conf"; then
  if sed -n '/^\[Theme\]/,/^\[/p' "$conf" | grep -q '^Current='; then
    sed -i '/^\[Theme\]/,/^\[/ s/^Current=.*/Current=zenbook/' "$conf"
  else
    sed -i '/^\[Theme\]/a Current=zenbook' "$conf"
  fi
else
  printf '\n[Theme]\nCurrent=zenbook\n' >> "$conf"
fi

echo "Installed. Preview: sddm-greeter-qt6 --test-mode --theme $dest"
echo "Old config saved to $conf.bak. It takes effect at the next logout or reboot."
