#!/bin/sh 

# - setup.sh -

# A little setup script for choosing different config
# Requirements: dialog (for prompts)



format_dialog() {
  declare -i j=1
  for i in $@; do
    echo $j $i
    (( j++ ))
  done
}

choose_dialog() {
  local title=$1
  shift
  local opts=`format_dialog $@`
  declare -i chosen=$(dialog --clear --menu "$menu_title" 15 40 4 $opts 2>&1 > /dev/tty)
  local j=1
  for i in $@; do
    [ $j -eq $chosen ] && break
    (( j++ ))
  done
  echo $i
}


choose_wm() {
  local wm=$(choose_dialog 'Which WM?' qtile awesome)
  clear
  echo "Setting up $wm config..."
  git submodule init --recurse $wm
}

choose_wm

# vim: filetype=sh:tabstop=2:textwidth=80:expandtab
