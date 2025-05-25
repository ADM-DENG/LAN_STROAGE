#!/bin/bash

# alist_init&install.sh
# Script to initialize and install Alist on Debian/Kali systems

set -e
# Function to print messages
log() {
    echo -e "\033[1;32m$1\033[0m"
}

INSTALL_DIR="/opt/alist"
# SERVICE_FILE="/etc/systemd/system/alist.service"
UserUser="${SUDO_USER:-$USER}"

if [ -d /opt/alist ]; then
    echo "\033[1;31m已存在/opt/alist文件夹，脚本终止。\033[0m"
    echo "请先确认/opt/alist文件夹，然后重新/停止运行脚本。"
    echo "informations: 请确认/处理异常!"
    echo "\033[1;31m1、/opt/alist\033[0m"
    exit 1
fi

# Create install directory
log "Creating install directory at $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r ./alist/. $INSTALL_DIR
# Make executable
sudo chown -R $UserUser:root $INSTALL_DIR

log "Alist installation and initialization complete!"
log "setting up alist desktop shortcut..."
if [ -d "$HOME/Desktop" ]; then
    # DESKTOP_PATH="$HOME/Desktop"
    cp "$INSTALL_DIR/alist.desktop" "$HOME/Desktop/"
    # chmod +x "$HOME/Desktop/alist.desktop"
elif [ -d "$HOME/桌面" ]; then
    # DESKTOP_PATH=/"$HOME/桌面"
    cp "$INSTALL_DIR/alist.desktop" "$HOME/桌面/"
    # chmod +x "$HOME/桌面/alist.desktop"
else
    # DESKTOP_PATH="$HOME"
    cp "$INSTALL_DIR/alist.desktop" "$HOME/"
    # chmod +x "$HOME/alist.desktop"
    echo "未检测到桌面目录，文件将放在用户主目录。"
fi
