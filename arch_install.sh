#!/bin/bash


packages=(
	ferdium-bin
	anki-bin
	ark
	bitwarden
	bluez
#blueman
	brightnessctl
	cups
	docker
	fastfetch
	firefox
	fuse2
	git
	gimp
	grim
#hyprland
#hyprlock
#hyprpaper
#hyprpicker
	kitty
	mongodb-bin
	nano
	net-tools
	nodejs
	onlyoffice-bin
	pulseaudio
#postbird-bin
#postgresql
	postman-bin
	putty
	python
	sddm
	slurp
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
#waybar
	wine
	wl-clipboard
	wofi
)

install_software() {
    # First lets see if the package is there
    if yay -Q $1 &>> /dev/null ; then
        echo -e "$1 is already installed."
    else
        # no package found so installing
        echo -en "Now installing $1 ."
        yay -S --noconfirm $1 &>> $INSTLOG &
        show_progress $!
        # test to make sure package installed
        if yay -Q $1 &>> /dev/null ; then
            echo -e "$1 was installed."
        else
            # if this is hit then a package is missing, exit to review log
            echo -e "$1 install had failed, please check the install.log"
            exit
        fi
    fi
}

if [ ! -f /sbin/yay ]; then  
    echo -en "Configuering yay."
    git clone https://aur.archlinux.org/yay.git &>> $INSTLOG
    cd yay
    makepkg -si --noconfirm
    if [ -f /sbin/yay ]; then
        echo -e "yay configured"
        cd ..
        
        # update the yay database
        echo -en "Updating yay."
        yay -Suy --noconfirm
        echo -e "yay updated."
    else
        # if this is hit then a package is missing, exit to review log
        echo -e "yay install failed, please check the install.log"
        exit
    fi
fi
