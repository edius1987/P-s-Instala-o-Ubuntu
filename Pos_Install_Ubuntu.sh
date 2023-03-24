#!/usr/bin/env bash

# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------ CABEÇALHO -------------------------------------------------- #
## AUTOR: Edius Ferreira
# ---Created on Wed Feb 15 23:33:30 2023---
## EMAIL: ediusferreira@gmail.com
## GITHUB: edius1987
## NOME: Pós Instalação Ubuntu
## DESCRIÇÃO:
###			Script de pós instalação desenvolvido para base Ubuntu 22.04, 
###			baseado em meu uso pessoal dos programas, configurações e personalizações.
## LICENÇA: MIT License
## Copyright (c) 2023 Edius Ferreira
## VERSÂO: Beta - versão em estágio ainda de desenvolvimento
### Para utilizar baixe e use o comando "./Pos_Install_Ubuntu.sh".

# ------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------- VARIÁVEIS E REQUISITOS ----------------------------------------- #

# Variávveis e links de download dinâmicos.
ppas=(appimagelauncher-team/stable teejee2008/foss)
url_flathub="https://flathub.org/repo/flathub.flatpakrepo"
url_nerd-fonts="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf"
url_oh_my-bash="https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh"
url_MX="https://github.com/MX-Linux/mx-conky-data.git"
### Programas para instalação e desinstalação.
apps_remover=(	gnome-abrt 
	gnome-boxes
	gedit 
	gnome-clocks 
	gnome-connections 
	gnome-contacts 
	gnome-photos 
	gnome-software 
	gnome-text-editor 
	gnome-tour 
	libreoffice-* 
	usb-creator-gtk 
	totem 
	rhythmbox
	thunderbird
	yelp)

apps=(cheese
	wget
	net-tools
	conky-manager2
	curl
	synaptic
	appimagelauncher
	openssh-server
	fonts-powerline
	python3.11
	python3-pip
	obs-studio
	npm
	npx
	nodejs
	jupyter-notebook
	cowsay
	papirus-folders
	papirus-icon-theme 
	ffmpegthumbnailer 
	flameshot 
	fortune-mod 
	gnome-tweaks 
	fonts-croscore
	heroic-games-launcher-bin 
	hugo 
	lolcat 
	lutris 
	mangohud 
	neofetch 
	virt-manager 
	steam-installer
	steam-devices
	steam
	unrar-free)

flatpak=(com.github.GradienceTeam.Gradience 
	nl.hjdskes.gcolor3 
	org.gimp.GIMP 
	org.ksnip.ksnip
	com.github.johnfactotum.Foliate 
	org.libreoffice.LibreOffice 
	de.haeckerfelix.Fragments
	org.remmina.Remmina
	com.github.muriloventuroso.easyssh
	com.raggesilver.BlackBox
	com.github.xournalpp.xournalpp
	com.github.jeromerobert.pdfarranger
	ca.desrt.dconf-editor
	com.vixalien.sticky
	net.cozic.joplin_desktop
	org.kde.krita
	org.localsend.localsend_app
	com.github.maoschanz.drawing
	com.microsoft.Edge
	com.brave.Browser
	org.gnome.Lollypop
	org.telegram.desktop)

snaps=(spotify discord photogimp vlc atom slack teams-for-linux) 


# ------------------------------------------------------------------------------------------------------------- #
# --------------------------------------------------- TESTE --------------------------------------------------- #
### Check se a distribuição é a correta.
# Obter a versão do sistema
version=$(lsb_release -rs)

# Verificar se a versão é 22.04
if [ "$version" == "22.04" ]; then
    echo "O sistema está executando o Ubuntu 22.04. Iniciando instalação..."
else
    echo "Este script é compatível apenas com o Ubuntu 22.04."
    exit 1
fi

## Adicionando PPAs
echo 'Adicionando PPAs'
echo
for ppa in ${ppas[@]}; do
  apt-add-repository "ppa:"$ppa  -y
done

rm -rf /etc/apt/preferences.d/nosnap.pref
apt update


# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock


### Desinstalando apps desnecessários.
for nome_do_programa in "${apps_remover[@]}"; do
    sudo apt remove "$nome_do_programa" -y
done

### Atualizando sistema após adição de novos repositórios.
sudo apt upgrade -y

# Instalar programas no apt
for nome_do_programa in ${apps[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$apps" -y
  else
    echo "[INSTALADO] - $apps"
  fi
done

echo 'Instalando Snaps e Flatpaks'
snap install ${snaps[@]}
snap install --classic ${snaps_classic[@]}
flatpak remote-add --if-not-exists flathub ${url_flathub[@]}
flatpak install flathub -y ${flatpak[@]}

### Configurando Gnome.
echo 'Configurando GNOME'
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click  true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true


### Configurando AppImages.
echo 'Configurando AppImages'
mkdir $HOME/Applications
mv *.AppImage $HOME/Applications
chmod 777 -r $HOME/Applications/

### Instalando PPA AppImageLauncher

wget "https://git.opendesktop.org/akiraohgaki/ocs-manager/uploads/d3dc42436b82d11360ebc96b38d4aaf4/ocs-manager-0.8.1-1-x86_64.AppImage"
chmod +x appimaged-x86_64.AppImage
./ocs-manager-0.8.1-1-x86_64.AppImage --install

echo 'Atualizando o sistema'
sudo apt dist-upgrade -y
sudo apt full-upgrade
sudo apt autoclean 

# ----------------------------- Personalização ----------------------------- #
if [ -d "$HOME/".local/share/fonts ]
then
	wget -cq --show-progress "$url_nerd-fonts" -P "$HOME"/.local/share/fonts
	fc-cache -f -v >/dev/null
else
	mkdir -p "$HOME"/.local/share/fonts
	wget -cq --show-progress "$url_nerd-fonts" -P "$HOME"/.local/share/fonts
	fc-cache -f -v >/dev/null
fi

# ----------------------------- Oh my bash! ----------------------------- #
echo 'Instalando Oh My Bash!'
bash -c "$(url_oh_my-bash)"
fc-cache -f -v >/dev/null

# ----------------------------- MX-Conky-Data ----------------------------- #
echo 'Instalando MX-Conky-Data'
git "$(url_MX)" ~/.conky
fc-cache -f -v >/dev/null

# ----------------------------- MComplementos ----------------------------- #

# conky-startup.sh
#
# conky.desktop
#

neofetch

echo
echo
echo "Instalação finalizada, é recomendado reiniciar o sistema."
echo "Até mais e boa trabalho!"
echo 
