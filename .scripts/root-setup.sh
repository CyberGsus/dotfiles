#!/bin/sh

# CyberGsus
# https://github.com/CyberGsus

# root-setup.sh
# Description:
#   A shell script to install arch linux from the
#   arch-chroot part, including all the graphic environment
#   dependencies in order for my dotfiles to work.
# Usage:
#   1. Get the script using the raw link from github
#   2. move it to /mnt after running pacstrap
#   3. arch-chroot sh root-setup.sh

# TODO: on installing, qtile is preconfigured to watch a 'wlp2s0' device.
# maybe I should ask and modify it accordingly using vim commands
info() {
  echo -e "\x1b[1;38;5;255m[\x1b[1;38;5;69m*\x1b[1;38;5;255m] $@\x1b[m"
}

ok() {
  echo -e "\x1b[1;38;5;255m[\x1b[1;38;5;118m+\x1b[1;38;5;255m] $@\x1b[m"
}
err() {
  echo -e "\x1b[1;38;5;255m[\x1b[1;31m-\x1b[38;5;255m] $@\x1b[m"
  exit 1
}

install_aur() {
  command -v trizen > /dev/null 2>&1 || err "trizen not installed!"
  as_user trizen -Sy --noconfirm --needed $@ && ok "Installed \"$@\" from AUR helper" || err "Could not install from AUR helper"
}


uninstall_aur() {
  command -v trizen > /dev/null 2>&1 || err "trizen not installed!"
  as_user trizen -Rnsc --noconfirm --needed $@ && ok "Uninstalled \"$@\" from AUR helper" || err "Could not install from AUR helper"
}

install() {
  info "Installing \"$@\"..."
  pacman -Sy --noconfirm --needed $@ && ok "Installed $@" || err "Could not install"
}

uninstall() {
  info "Uninstalling \"$@\"..."
  pacman -Rnsc --noconfirm $@ || info "\"$@\" not uninstalled"
}

install_grub() {
  [ -d /sys/firmware/efi/efivars ] && install_grub_efi || install_grub_bios
}

install_grub_efi() {
  info "Installing GRUB for EFI..."
  install grub os-prober efibootmgr && \
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB && \
    grub-mkconfig -o /boot/grub/grub.cfg && \
    ok "Grub successfully installed" || err "Could not install GRUB to /boot."
  }

install_grub_bios() {
  local disk=`lsblk -lp | awk '/\/$/ {print $1}' | sed 's/[0-9]*//g' | uniq`
  info "Installing GRUB for BIOS at $disk..."
  install grub os-prober && \
    grub-install --target=i386-pc $disk && \
    grub-mkconfig -o /boot/grub/grub.cfg && \
    ok "Grub successfully installed" || err "Could not install GRUB to $disk."
  }

enable_microcode() {
  info "Trying to enable emicrocode updates..."
  local processor_type=`lscpu | awk '/Model\sname/ {print $3}' | tr '[:upper:]' '[:lower:]' | uniq`
  if [[ "$processor_type" =~ 'intel' ]]; then
    info "Detected intel processor"
    install intel-ucode
  elif [[ "$processor_type" =~ 'amd' ]]; then
    info "Detected AMD processor"
    install amd-ucode
  else
    info "No available microcode found..."
  fi
}

networking() {
  install networkmanager
  systemctl enable NetworkManager || err "Could not enable NetworkManager."
}

add_user() {
  read -p "Enter user name: " username
  useradd -G wheel,rfkill,network,audio,video $username
  info "Setting password for '$username'..."
  passwd $username
  info "Giving sudo permissions..."
  vim -c 'execute "normal! /Runas\<cr>2kiDefaults insults\<esc>/%wheel\<cr>^2xn^2x"' -c 'wqa!' /etc/sudoers
  info "Installing dotfiles..."
  install git
  git clone --recurse-submodules https://github.com/CyberGsus/dotfiles /home/$username
  info "Restoring permissions..."
  chown -R $username:users /home/$username
  info "Configuring shell..."
  chsh -s /bin/zsh $username
  info "Cleaning up..."
  rm -rf /home/$username/.git /home/$username/README.md /home/$username/screenshot.png
  ok "User '$username' successfully added."
}

as_user() {
  [ -z "$username" ] && err "No user configured!"
  echo -E $@ > /home/$username/tmp_script
  chown $username:users /home/$username/tmp_script
  su -c 'sh ~/tmp_script' $username
  rm -f /home/$username/tmp_script
}

install_trizen() {
  info "Installing trizen..."
  git clone https://aur.archlinux.org/trizen /home/$username/trizen
  chown -R $username:users /home/$username/trizen
  pushd /home/$username/trizen
  as_user makepkg -si --noconfirm --needed
  rm -rf "/home/$username/trizen"
  popd
}


install_de() {
  info "Installing drivers..."
  install xf86-video-intel xf86-video-vmware
  info "Installing desktop environment..."
  info "Installing window manager..."
  install_aur xorg-server xorg-apps xorg-xinit qtile xterm
  info "Installing display manager..."
  install_aur lightdm lightdm-webkit2-greeter lightdm-webkit-theme-aether
  systemctl enable lightdm
  info "Installing utilities..."
  install_aur emojione-picker-git network-manager-applet blueman light-locker picom xbindkeys usbutils
  info "Installing programs..."
  install_aur qutebrowser neovim alacritty discord tmux zsh zsh-autosuggestions zsh-syntax-highlighting autojump neofetch imagemagick nautilus dmenu
  chsh -s /bin/zsh $username || err "Something went wrong!"

  info "Installing neovim plugins..."
  as_user nvim -c 'PlugInstall'  -c 'qa!'
  info "Installing necessary python modules..."
  install python python-pip
  python3 -m pip install -U pip wheel setuptools
  pip3 install -U psutil numpy pillow
  install_aur python-xdg python-mpd2 python-iwlib python-dateutil python-keyring
  info "Installing fonts..."
  install_aur ttf-anonymous-pro ttf-droid ttf-font-awesome ttf-hack ttf-hackgen ttf-ibm-plex-mono ttf-ibm-plex ttf-inconsolata ttf-jetbrains-mono ttf-lato ttf-opensans ttf-roboto ttf-roboto-mono ttf-ubuntu-font-family noto-fonts-all
  info "Configuring pacman..."
  vim -c 'execute "silent! normal! /Color\<cr>^x"' -c 'execute "normal! /\\[multilib\\]\<cr>^xnx"' -c 'wqa!' /etc/pacman.conf
  ok "Installed desktop environment successfully"
}

install_blackarch() {
  info "Installing BlackArch Repos..."
  curl -O https://blackarch.org/strap.sh
  chmod +x strap.sh
  sh strap.sh
  rm -f strap.sh
  info "Changing OS info..."
  vim -c 'execute "normal! /NAME\<cr>2wciwBlackArch\<esc>n2w./LOGO\<cr>2wciwblackarch\<esc>"' -c 'wqa!' /usr/lib/os-release
}

[ $EUID = 0 ] || err "You are not root!" # Only run as root
# 0. Install some tools
if [ -z "$1" ]; then
  info "Base Install"
  read
  install wget curl vim base-devel

  # 1. Configure timezone and clock
  info "Configuring basic stuff..."
  ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
  hwclock --systohc
  timedatectl set-ntp true
  vim /etc/locale.gen -c 'execute "normal! /en_US.UTF-8\<cr>n"' -c 's/#//g' -c 'wqa!'
  locale-gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
  read -p "Enter hostname: " hostname
  echo "$hostname" > /etc/hostname
  echo "\n127.0.0.1\t\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts
  info "Setting the root password..."
  passwd

  # 2. Install bootloader
  [ -d /boot/grub ] || install_grub
  enable_microcode
  networking
  # Add script to bash_profile so executed on root login
  [ -f $HOME/.bash_profile ] && mv $HOME/.bash_profile $HOME/.bash_profile.bak
  echo "sh /$0 a" > $HOME/.bash_profile
  ok "Base Install complete! Please dont forget to genfstab, unmount and reboot :)"
else
  [ -f $HOME/.bash_profile.bak ] && mv -f $HOME/.bash_profile.bak $HOME/.bash_profile
  vim -c "%!grep -v \"/$0\"" -c 'wqa!' $HOME/.bash_profile
  info "User Install"
  read
  add_user
  install_trizen
  install_de
  info "Enabling ssh access..."
  install openssh
  systemctl enable sshd
  install_blackarch
  # vim -c 'execute "silent! normal! /PermitRootLogin\<cr>^xewciwyes\<esc>"' -c 'wqa!' /etc/ssh/sshd_config # enable root login
  rm -f "$0" # delete the script
fi
