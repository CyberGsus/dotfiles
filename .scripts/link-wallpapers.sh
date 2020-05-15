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

for file in $WALLPAPER_DIR/**/*; do
  [ -e "$LINK_DIR/${file##*/}" ] && continue # if file/link already exists in directory, dont make it
  [ ! -f "$file" ] && continue # if file is directory, dont process it
  ln -s "$file" "$LINK_DIR/${file##*/}"
done
