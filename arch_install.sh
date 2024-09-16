#!/bin/bash

packages=(
	nano
	net-tools
	bluez
	pulseaudio
	fuse2
	brightnessctl
	cups
	python
	wine
	nodejs
	docker
	fastfetch
	sddm

	kitty
	blueman
	bitwarden
	ferdium-bin
	anki-bin
	ark
	firefox
	gimp
	mongodb-bin
	mongodb-compass
	onlyoffice-bin
	pavucontrol
	postman-bin
	spotify-launcher
	texlive-bin
	texlive-basic
	texlive-bibtexextra
	texlive-binextra
	texlive-fontsextra
	texlive-fontsrecommended
	texlive-fontutils
	texlive-langgerman
	texlive-latex
	texlive-latexextra
	texlive-latexrecommended
	texlive-mathscience
	texlive-pictures
	thunar
	vscodium-bin

	grim
	slurp
	hyprlock
	hyprpaper
	hyprpicker
	waybar
	wl-clipboard
	wofi
	mako
)

# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

install_software() {

	if yay -Q $1 &>>/dev/null; then
		echo -e "$1 is already installed."
	else
		echo -en "Now installing $1 ."
		yay -S --noconfirm $1
		if yay -Q $1 &>>/dev/null; then
			echo -e "$1 was installed."
		else
			echo -e "$1 install had failed, please check the install.log"
			exit
		fi
	fi
}

# give the user an option to exit out
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to continue with the install (y,n) ' CONTINST
if [[ $CONTINST == "Y" || $CONTINST == "y" ]]; then
	echo -e "$CNT - Setup starting..."
	sudo touch /tmp/hyprv.tmp
else
	echo -e "$CNT - This script will now exit, no changes were made to your system."
	exit
fi

if [ ! -f /sbin/yay ]; then
	echo -en "Configuring yay."
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	if [ -f /sbin/yay ]; then
		echo -e "yay configured"
		cd ..

		echo -en "Updating yay."
		yay -Suy --noconfirm
		echo -e "yay updated."
	else
		echo -e "yay install failed, please check the install.log"
		exit
	fi
fi

echo -e "Installing Hyprland, this may take a while..."
install_software hyprland

echo -e "Installing main components, this may take a while..."
for SOFTWR in ${packages[@]}; do
	install_software $SOFTWR
done

echo -e "Starting the Bluetooth Service..."
sudo systemctl enable --now bluetooth.service
sleep 2

echo -e "Enabling the SDDM Service..."
sudo systemctl enable sddm
sleep 2

cp -R dotfiles ~/.config/

reboot