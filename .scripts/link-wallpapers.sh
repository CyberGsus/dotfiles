#!/bin/sh

# CyberGsus
# https://github.com/CyberGsus/dotfiles

# link-wallpapers.sh
# Usage : [ WALLPAPER_DIR='directory' ] [ LINK_DIR='link_dir' ] sh link-wallpapers.sh
# Description:
#       Walks through the wallpaper directory recursively, and
#       makes symbolic links in the link directory specified or the main 
#       wallpaper directory if not specified to all the wallpapers in subdirectories


WALLPAPER_DIR=${WALLPAPER_DIR:-"$HOME/.local/share/wallpapers"}
LINK_DIR=${LINK_DIR:-$WALLPAPER_DIR/links}

[ -d "$WALLPAPER_DIR" ] || mkdir -p "$WALLPAPER_DIR"
[ -d "$LINK_DIR" ]      || mkdir -p "$LINK_DIR"


link_wallpaper() {
  [ -e "$LINK_DIR/${1##*/}" ] && return 1
  [ ! -f "$1" ] && return 1
  return $(ln -s "$1" "$LINK_DIR/${file##*/}")
}

for file in $WALLPAPER_DIR/**/*; do
  link_wallpaper $file
done
for file in $WALLPAPER_DIR/*; do
  link_wallpaper $file
done
