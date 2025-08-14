#!/bin/bash
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~         _           _    _                 ~
# ~      __| | ___  ___| | _| |_ ___  _ __     ~
# ~     / _` |/ _ \/ __| |/ / __/ _ \| '_ \    ~
# ~    | (_| |  __/\__ \   <| || (_) | |_) |   ~
# ~     \__,_|\___||___/_|\_\\__\___/| .__/    ~
# ~                                  |_|       ~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal-gnome
killall -e xdg-desktop-portal-kde
killall -e xdg-desktop-portal

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland

systemctl --user stop pipewire
systemctl --user stop xdg-desktop-portal
systemctl --user stop xdg-desktop-portal-gtk
systemctl --user stop xdg-desktop-portal-hyprland

swww-daemon

/usr/lib/xdg-desktop-portal-hyprland

if [ -f /usr/lib/xdg-desktop-portal-gtk ];then
    /usr/lib/xdg-desktop-portal-gtk
fi

/usr/lib/xdg-desktop-portal

systemctl --user start pipewire
systemctl --user start xdg-desktop-portal
systemctl --user start xdg-desktop-portal-gtk
systemctl --user start xdg-desktop-portal-hyprland
