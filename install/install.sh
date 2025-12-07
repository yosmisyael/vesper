#!/bin/bash

REPO_URL="https://github.com/yosmisyael/vesper.git"

VESPER_DIR="$HOME/.config/vesper"
CONFIG_DIR="$HOME/.config"
HOME_DIR="$HOME"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Starting Configuration Setup...${NC}"

mkdir -p "$CONFIG_DIR"

if [ -d "$VESPER_DIR" ]; then
    echo -e "${BLUE}Directory $VESPER_DIR already exists. Pulling latest changes...${NC}"
    git -C "$VESPER_DIR" pull
else
    echo -e "${BLUE}Cloning repository into $VESPER_DIR...${NC}"
    git clone "$REPO_URL" "$VESPER_DIR"
fi

echo -e "${BLUE}Moving files to target locations...${NC}"

if [ -f "$VESPER_DIR/shell/.zshrc" ]; then
    echo "  -> Copying .zshrc to $HOME_DIR/.zshrc"
    cp -f "$VESPER_DIR/shell/.zshrc" "$HOME_DIR/.zshrc"
else
    echo "  ! Warning: .zshrc not found in $VESPER_DIR/shell/"
fi

if [ -d "$VESPER_DIR/starship" ]; then
    echo "  -> Moving starship config to $CONFIG_DIR/"
    cp -rf "$VESPER_DIR/starship/"* "$CONFIG_DIR/"
    rm -rf "$VESPER_DIR/starship"
fi

DIRS_TO_MOVE=("fastfetch" "hypr" "kitty" "matugen" "rofi" "shell" "swaync" "waybar" "wallpaper")

for dir in "${DIRS_TO_MOVE[@]}"; do
    SOURCE="$VESPER_DIR/$dir"
    DEST="$CONFIG_DIR/$dir"

    if [ -d "$SOURCE" ]; then
        echo "  -> Moving $dir to $DEST"
        cp -rf "$SOURCE" "$CONFIG_DIR/"
        rm -rf "$SOURCE"
    else
        echo "  ! Warning: Directory $dir not found in repo."
    fi
done

if [ -d "$VESPER_DIR/scripts" ]; then
    echo "  -> Scripts directory verified at $VESPER_DIR/scripts"
else
    echo "  ! Warning: Scripts directory missing."
fi

echo -e "${GREEN}Configuration setup complete!${NC}"
