#!/bin/bash

gsettings set org.gnome.desktop.interface gtk-theme ""

sleep 0.2

gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"
gsettings set org.gnome.desktop.interface color-scheme "prefer-light"

killall -HUP xsettingsd
