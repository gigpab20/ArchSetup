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
	postbird-bin
	postgres
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
	dolphin
	vscodium-bin
	jetbrains-toolbox
    flameshot
	otf-font-awesome
	jdk11-openjdk
	jdk17-openjdk
	jdk21-openjdk
	docker-compose
	npm
	otf-font-awesome
	ttf-font-awesome
)

i3=(
    i3-wm
    rofi
	i3lock
	polybar
	xrandr
	picom
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

echo hyprland or i3
read desicion

if [[$desicion == "h"]]; then

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

else then
    echo -e "Installing i3, this may take a while..."
    install_software i3-wm
    for SOFTWR in ${i3[@]}; do
	    install_software $SOFTWR
    done

    rm -rf ~/.config/kitty/
    cp -r dotfiles/kitty ~/.config/
	cp -r dotfiles/dolphinrc ~/.config/
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


mkdir ~/Downloads/
cd ~/Downloads/
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
mkdir ~/development/
tar -xf ~/Downloads/flutter_linux_3.24.3-stable.tar.xz -C ~/development/
echo 'export PATH="~/development/flutter/bin:$PATH"' >> ~/.bash_profile

cd ~/Downloads/
curl -O https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
chmod +x ~/Downloads/Anaconda3-2024.06-1-Linux-x86_64.sh 
sudo ./Anaconda3-2024.06-1-Linux-x86_64.sh

mkdir ~/Documents/
mkdir ~/Pictures/Screenshots

sudo mkdir /mnt/data_disk
sudo mount /dev/nvme1n1p1 /mnt/data_disk
sudo chown -R $USER:$USER /mnt/data_disk

sudo blkid /dev/nvme1n1p1
sudo nano /etc/fstab
UUID=UUID=e6fed6a2-1419-452d-b970-873adbbedc3e /mnt/Data ext4 defaults 0 2 /mnt/data ext4 defaults 0 2



sudo su - postgres
initdb -D /var/lib/postgres/data
exit

sudo systemctl enable postgresql
sudo systemctl start postgresql

exit


reboot