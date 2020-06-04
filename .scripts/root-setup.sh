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
  as_user trizen -Rnsc --noconfirm --needed $@ && ok "Uninstalled \"$@\" from AUR helper" || err "Could not uninstall from AUR helper"
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
  info "Installing GRUB..."
  install grub os-prober
  [ -d /sys/firmware/efi/efivars ] && install_grub_efi || install_grub_bios
  # info "Installing GRUB theme..."
  # git clone https://github.com/fghibellini/arch-silence
  # vim -c 'execute "silent! normal! /^#GRUB_THEME\<cr>oGRUB_THEME=\"/boot/grub/themes/arch-silence/theme.txt\"\<esc>"' -c 'wqa!' /etc/default/grub
  # rm -rf arch-silence
  inst git
  git clone https://github.com/vinceliuice/grub2-themes
  pushd grub2-themes
  ./install.sh -l
  popd
  rm -rf grub2-themes
  ok "Theme installed."
  grub-mkconfig -o /boot/grub/grub.cfg
  ok "GRUB Installed!"
}

install_grub_efi() {
  info "Installing GRUB for EFI..."
  install efiboomgr && \
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB && \
    ok "Grub successfully installed" || err "Could not install GRUB to /boot."
  }

install_grub_bios() {
  local disk=`lsblk -lp | awk '/\/$/ {print $1}' | sed 's/[0-9]*//g' | uniq`
  info "Installing GRUB for BIOS at $disk..."
  grub-install --target=i386-pc $disk && \
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
  git clone https://github.com/CyberGsus/dotfiles /home/$username
  # Forca zsh
  install zsh
  pushd /home/$username
  for submodule in .zsh .local/share/icons/candy-icons .tmux .zsh/pure .config/nvim/plugged; do
    git submodule update --init --recursive $submodule
  done
  popd
  info "Restoring permissions..."
  chown -R $username:users /home/$username
  info "Configuring shell..."
  chsh -s /bin/zsh $username
  info "Cleaning up..."
  rm -rf /home/$username/README.md /home/$username/screenshot.png
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
  install pacman-contrib
  git clone https://aur.archlinux.org/trizen /home/$username/trizen
  chown -R $username:users /home/$username/trizen
  pushd /home/$username/trizen
  as_user makepkg -si --noconfirm --needed
  popd
  rm -rf "/home/$username/trizen"
}

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
  declare -i chosen=`format_dialog $@ | xargs dialog --menu "$title" 15 40 4 2>&1 /dev/tty`
  declare -i j=1
  for i in $@; do
    [ $j -eq $chosen ] && break
    (( j++ ))
  done
  echo $i
}


install_de() {
  info "Installing drivers..."
  install xorg-drivers
  info "Installing desktop environment..."
  install python python-pip

  local chosen_wm=$(choose_dialog 'Which Desktop Environment to Use?' qtile awesome)

  case "$chosen_wm" in
    'qtile')
      info "Installing qtile..."
      install_aur xorg-server xorg-apps xorg-xinit qtile xterm
      info "Setting up qtile configuration..."
      pushd /home/$username
      as_user git submodule init --recurse .config/qtile-config
      as_user ln -s ~/.config/qtile ~/.config/qtile-config
      popd
      info 'Installing widget deps...'
      pip3 install -U psutil numpy pillow


      install_aur python-xdg python-mpd2 python-iwlib python-dateutil python-keyring dmenu iproute2

      # Get the network address from default routing
      local ifname=`ip route | cut -d$'\n' -f1 | cut -d' ' -f5`
      vim -c "execute \"silent! normal! /wlp2s0\\<cr>ciw$ifname\\<esc>\"" -c 'wqa!' /home/$username/.config/qtile/custom/widgets.py


      ok "Qtile installed"

      ;;
    'awesome')
      info "Installing awesome..."
      install awesome
      info "Setting up awesome configuration..."
      pushd /home/$username/
      as_user git submodule update --recursive .config/awesome
      as_user cd ~/.config/awesome '&&' sh setup.sh
      popd
      ok "Awesome installed"
      ;;
  esac

  info "Installing display manager..."
  install_aur lightdm-webkit-theme-aether
  systemctl enable lightdm
  info "Installing utilities..."
  install_aur emojione-picker-git network-manager-applet blueman light-locker picom xbindkeys usbutils
  info "Installing programs..."
  install_aur qutebrowser neovim alacritty discord tmux zsh-autosuggestions zsh-syntax-highlighting autojump neofetch imagemagick nautilus

  info "Installing neovim plugins..."
  as_user nvim -c 'qa!' # Crashes
  as_user nvim -c 'PlugInstall' -c 'qa!'
  info "Installing fonts..."
  install_aur ttf-droid ttf-font-awesome ttf-hack ttf-ibm-plex ttf-inconsolata ttf-jetbrains-mono ttf-lato ttf-opensans ttf-roboto ttf-roboto-mono ttf-ubuntu-font-family noto-fonts-all
  # Remove git stuff from home directory
  rm -rf /home/$username/.git*
  info "Installing cursor..."
  install_aur breeze-snow-cursor-theme
  as_user vim -c 'execute "silent! normal! /gtk-cursor-theme-name\<cr>f=lCBreeze_Snow\<esc>"' -c 'wqa!' ~/.config/gtk-3.0/settings.ini
  as_user vim -c 'execute "silent! normal! /gtk-cursor-theme-name\<cr>ci\"Breeze_Snow\<esc>"' -c 'wqa!' ~/.gtkrc-2.0
  as_user vim -c 'execute "silent! normal! jf=lCBreeze_Snow\<esc>"' -c 'wqa!' ~/.icons/default/index.theme
  ok "Installed desktop environment successfully"
}

install_blackarch() {
  info "Installing BlackArch Repos..."
  # Make tmp directory
  tmp="$(mktemp -d /tmp/blackarch_xtrap.XXXXXXXX)"
  trap 'rm -rf $tmp' EXIT
  pushd $tmp || exit 1

  # Check internet
  curl -s --connect-timeout 8 https://archlinux.org > /dev/null 2>&1 || exit 1

  # Fetch keyring
  curl -fO 'https://www.blackarch.org/keyring/blackarch-keyring.pkg.tar.xz{,.sig}'

  # Verify keyring
  ## Download key
  for serv in hkp://pool.sks-keyservers.net pgp.mit.edu ; do
    gpg --keyserver $serv --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 && break
  done
  [ $? -eq 0 ] || exit 1

## Verify signature
gpg --keyserver-options no-auto-key-retrieve \
  --with-fingerprint blackarch-keyring.pkg.tar.xz.sig || exit 1

# remove signature
[ -f "blackarch-keyring.pkg.tar.xz.sig" ] && rm -f blackarch-keyring.pkg.tar.xz.sig

pacman-key --init

# Install keyring
pacman --config /dev/null --noconfirm -U blackarch-keyring.pkg.tar.xz || exit 1
pacman-key --populate


# Install mirrors
curl https://blackarch.org/blackarch-mirrorlist -o /etc/pacman.d/blackarch-mirrorlist
sed -i '/blackarch/{N;d}' /etc/pacman.conf
cat >> /etc/pacman.conf <<EOF
[blackarch]
Include = /etc/pacman.d/blackarch-mirrorlist
EOF
pacman -Syy
ok "Blackarch Mirrors Installed."
popd
info "Changing neofetch config..."
as_user 'neofetch; clear' # Make sure neofetch.conf is generated
as_user vim -c 'execute "silent! normal! /ascii_distro=\<cr>f"lci"blackarchjk"' -c 'wqa!' /home/$username/.config/neofetch/config.conf
}

[ $EUID = 0 ] || err "You are not root!" # Only run as root
# 0. Install some tools
if [ -z "$1" ]; then
  info "Base Install"
  info "Configuring pacman..."
  install wget curl vim base-devel dialog xorg-xset
  vim -c 'execute "silent! normal! /Color\<cr>^x"' -c 'execute "normal! /\\[multilib\\]\<cr>^xjx"' -c 'wqa!' /etc/pacman.conf

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
  echo -e "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts
  info "Setting the root password..."
  passwd

  # 2. Install bootloader
  [ -d /boot/grub ] || install_grub
  enable_microcode
  networking
  # Add script to bash_profile so executed on root login
  [ -f $HOME/.bash_profile ] && mv $HOME/.bash_profile $HOME/.bash_profile.bak
  echo "sh $0 a" > $HOME/.bash_profile
  ok "Base Install complete! Please dont forget to genfstab, unmount and reboot :)"
else
  [ -f $HOME/.bash_profile.bak ] && mv -f $HOME/.bash_profile.bak $HOME/.bash_profile || rm -r $HOME/.bash_profile
  vim -c "%!grep -v \"/$0\"" -c 'wqa!' $HOME/.bash_profile
  add_user
  install_trizen
  install_de
  info "Enabling ssh access..."
  install openssh
  systemctl enable sshd
  install_blackarch
  # remove unneeded stuff
  pacman -Qdtq | xargs pacman -Rns --noconfirm
  # Remove NOPASSWD permissions from user
  vim -c 'execute "silent! normal! /%wheel\<cr>n^i#\<esc"' -c 'wqa!' /etc/sudoers
  # vim -c 'execute "silent! normal! /PermitRootLogin\<cr>^xewciwyes\<esc>"' -c 'wqa!' /etc/ssh/sshd_config # enable root login
  rm -f "$0" # delete the script
fi
