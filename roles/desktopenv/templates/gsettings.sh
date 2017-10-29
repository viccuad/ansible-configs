#!/bin/bash

settings="org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/adwaita-timed.xml'
org.gnome.desktop.datetime automatic-timezone true
org.gnome.desktop.input-sources sources [('xkb', 'us+altgr-intl')]
org.gnome.desktop.input-sources xkb-options ['terminate:ctrl_alt_bksp', 'caps:ctrl_modifier', 'compose:prsc', 'lv3:ralt_switch']
org.gnome.desktop.interface clock-format '24h'
org.gnome.desktop.interface clock-show-date true
org.gnome.desktop.interface clock-show-seconds false
org.gnome.desktop.interface cursor-theme 'Paper'
org.gnome.desktop.interface document-font-name 'Sans 12'
org.gnome.desktop.interface enable-animations true
org.gnome.desktop.interface font-name 'Cantarell 12'
org.gnome.desktop.interface gtk-theme 'Materia-light-compact'
org.gnome.desktop.interface icon-theme 'Paper'
org.gnome.desktop.interface monospace-font-name 'DejaVu Sans Mono for Powerline 12'
org.gnome.desktop.interface scaling-factor uint32 0
org.gnome.desktop.interface show-battery-percentage true
org.gnome.desktop.interface text-scaling-factor 1.0
org.gnome.desktop.media-handling automount-open true
org.gnome.desktop.media-handling automount true
org.gnome.desktop.media-handling autorun-never false
org.gnome.desktop.media-handling autorun-x-content-ignore @as []
org.gnome.desktop.media-handling autorun-x-content-open-folder @as []
org.gnome.desktop.media-handling autorun-x-content-start-app @as []
org.gnome.desktop.privacy hide-identity false
org.gnome.desktop.privacy old-files-age uint32 30
org.gnome.desktop.privacy recent-files-max-age -1
org.gnome.desktop.privacy remember-app-usage true
org.gnome.desktop.privacy remember-recent-files false
org.gnome.desktop.privacy remove-old-temp-files false
org.gnome.desktop.privacy remove-old-trash-files false
org.gnome.desktop.privacy report-technical-problems false
org.gnome.desktop.privacy send-software-usage-stats false
org.gnome.desktop.privacy show-full-name-in-top-bar true
org.gnome.desktop.screensaver color-shading-type 'solid'
org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/gnome/adwaita-timed.xml'
org.gnome.desktop.wm.keybindings switch-to-workspace-down ['<Super>j', '<Control><Alt>Down']
org.gnome.desktop.wm.keybindings switch-to-workspace-up ['<Super>k', '<Control><Alt>Up']"

while read -r line; do
    gsettings set "$line"
done <<< "$settings"
