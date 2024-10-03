#!/bin/bash

packages=(
	nano
	net-tools
	bluez
	pulseaudio
	pulseaudio-bluetooth
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
	nemo
	vscodium-bin
	jetbrains-toolbox
    flameshot
	otf-font-awesome
	openjdk-11
	openjdk-17
	openjdk-21

)

i3=(
    i3-wm
    rofi
)

hyprland=(
    grim
	fkill
	slurp
	hyprlock
	hyprpaper
	hyprpicker
	waybar
	wl-clipboard
	wofi
	mako
)

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

pacman -R yay
rm -rf yay

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

echo -e "hyprland or i3? (h|i)"
read DECISION
if [[$DECISION == "h"]]; then

    echo -e "Installing Hyprland, this may take a while..."
    install_software hyprland
    for SOFTWR in ${hyprland[@]}; do
	    install_software $SOFTWR
    done

    rm -rf ~/.config/hypr/
    rm -rf ~/.config/kitty/
    rm -rf ~/.config/waybar/

    cp -r dotfiles/hypr ~/.config/
    cp -r dotfiles/kitty ~/.config/
    cp -r dotfiles/waybar ~/.config/

else
    echo -e "Installing i3, this may take a while..."
    install_software i3-wm
    for SOFTWR in ${i3[@]}; do
	    install_software $SOFTWR
    done

    rm -rf ~/.config/kitty/
    cp -r dotfiles/kitty ~/.config/
fi

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



cd ~/Downloads/
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
mkdir ~/development/
tar -xf ~/Downloads/flutter_linux_3.24.3-stable.tar.xz -C ~/development/
echo 'export PATH="~/development/flutter/bin:$PATH"' >> ~/.bash_profile

cd ~/Downloads/
curl -O https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
chmod +x Anaconda3-2024.06-1-Linux-x86_64.sh 
sudo ./Anaconda3-2024.06-1-Linux-x86_64.sh

mkdir ~/Documents/
mkdir ~/Pictures/Screenshots

reboot