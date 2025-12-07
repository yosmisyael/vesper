#!/bin/bash

# --------------------------------------------------------------------------
#                                                                
#                                                                
#     /$$    /$$ /$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$   /$$$$$$ 
#    |  $$  /$$//$$__  $$ /$$_____/ /$$__  $$ /$$__  $$ /$$__  $$
#     \  $$/$$/| $$$$$$$$|  $$$$$$ | $$  \ $$| $$$$$$$$| $$  \__/
#      \  $$$/ | $$_____/ \____  $$| $$  | $$| $$_____/| $$      
#       \  $/  |  $$$$$$$ /$$$$$$$/| $$$$$$$/|  $$$$$$$| $$      
#        \_/    \_______/|_______/ | $$____/  \_______/|__/      
#                                  | $$                          
#                                  | $$                          
#                                  |__/
#
# required packages installer
# --------------------------------------------------------------------------

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}[ERROR] Do not run this script as root!${RESET}"
    echo "Paru and makepkg must be run as a normal user."
    exit 1
fi

echo -e "${GREEN}Starting installation...${RESET}"

PKGS_PACMAN=(
    hyprland
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-utils
    gtk3
    kitty
    polkit
    polkit-gnome
    brightnessctl
    hyprpicker
    rofi
    nwg-look
    zsh
    starship
    qt6-wayland
    qt5-wayland
    udiskie
    hypridle
    hyprlock
    sddm
    cliphist
    wl-clipboard
    blueman
    imagemagick
    jq
    slurp
    fastfetch
    kvantum
    kvantum-qt5
    qt5ct
    qt6ct
    firefox
    dolphin
    otf-font-awesome
    otf-font-awesome-5
    ttf-jetbrains-mono-nerd
    ffmpegthumbs
    waybar
    power-profiles-daemon
)

# AUR Packages (paru)
PKGS_AUR=(
    swww
    papirus-folders
    waypaper
    matugen-bin
    sddm-theme-astronaut
    grimblast
)

echo -e "${YELLOW}Updating system and installing base-devel/git...${RESET}"
sudo pacman -Syu --noconfirm base-devel git

if ! command -v paru &> /dev/null; then
    echo -e "${YELLOW}Paru not found. Installing paru-bin...${RESET}"
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si --noconfirm
    cd ..
    rm -rf paru-bin
else
    echo -e "${GREEN}Paru is already installed.${RESET}"
fi

echo -e "${YELLOW}Installing Official Packages...${RESET}"
if sudo pacman -S --needed --noconfirm "${PKGS_PACMAN[@]}"; then
    echo -e "${GREEN}Official packages installed successfully.${RESET}"
else
    echo -e "${RED}Some official packages failed to install. Check output above.${RESET}"
fi

echo -e "${YELLOW}Installing AUR Packages...${RESET}"
if paru -S --needed --noconfirm "${PKGS_AUR[@]}"; then
    echo -e "${GREEN}AUR packages installed successfully.${RESET}"
else
    echo -e "${RED}Some AUR packages failed to install.${RESET}"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh-My-Zsh...${RESET}"
    # Unattended install so it doesn't switch shell immediately and stop the script
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Change default shell to zsh
    sudo chsh -s $(which zsh) $USER
    echo -e "${GREEN}Oh-My-Zsh installed and shell set to Zsh.${RESET}"
else
    echo -e "${GREEN}Oh-My-Zsh is already installed.${RESET}"
fi

echo -e "${YELLOW}Enabling system services...${RESET}"

# SDDM Display Manager
sudo systemctl enable sddm
# Bluetooth
sudo systemctl enable bluetooth
# Power Profiles
sudo systemctl enable power-profiles-daemon

echo -e "${GREEN}--------------------------------------${RESET}"
echo -e "${GREEN}   Installation Complete!             ${RESET}"
echo -e "${GREEN}   Please Reboot your system.         ${RESET}"
echo -e "${GREEN}--------------------------------------${RESET}"
