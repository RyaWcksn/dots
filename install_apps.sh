#!/bin/bash

set -e

APP_LIST_FILE="apps.json"
UPDATE_APPS=false

if [[ "$1" == "--update" ]]; then
  UPDATE_APPS=true
fi

# --- Function: Install jq ---
install_jq() {
  if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      sudo apt update
      sudo apt install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew first..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
      brew install jq
    else
      echo "Unsupported OS for jq installation."
      exit 1
    fi
  fi
}

# --- Function: Ensure universe repo enabled (Ubuntu only) ---
enable_universe_repo() {
  if ! grep -E -q "^deb .*universe" /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null; then
    echo "Enabling universe repository..."
    sudo add-apt-repository universe -y
    sudo apt update
  fi
}

# --- Function: Install a single app on Linux ---
install_app_linux() {
  local app=$1

  echo "Installing $app..."
  if dpkg -s "$app" &>/dev/null; then
    if $UPDATE_APPS; then
      echo "Updating $app via APT..."
      sudo apt install --only-upgrade -y "$app"
    else
      echo "$app already installed via APT. Skipping."
    fi
    return
  fi

  if sudo apt install -y "$app"; then
    echo "Installed $app via APT."
    return
  else
    echo "$app not found in APT, trying Snap..."
    if snap list | grep -qw "$app"; then
      echo "$app already installed via Snap. Skipping."
    else
      sudo snap install "$app" && echo "Installed $app via Snap." || echo "❌ Failed to install $app."
    fi
  fi
}

# --- Function: Install multiple apps on Linux ---
install_apps_linux() {
  enable_universe_repo
  sudo apt update
  for app in $apps; do
    install_app_linux "$app"
  done
}

# --- Function: Install a single app on macOS ---
install_app_brew() {
  local app=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
    local capitalized_app="$(tr '[:lower:]' '[:upper:]' <<< ${app:0:1})${app:1}"
    if [[ -d "/Applications/$capitalized_app.app" && "$UPDATE_APPS" = false ]]; then
      echo "$capitalized_app.app exists in /Applications. Skipping."
      return
    fi
  fi

  if brew list --formula | grep -qx "$app"; then
    if $UPDATE_APPS; then
      echo "Upgrading formula $app..."
      brew upgrade "$app" || true
    else
      echo "$app already installed as formula. Skipping."
    fi
    return
  fi

  if brew list --cask | grep -qx "$app"; then
    if $UPDATE_APPS; then
      echo "Upgrading cask $app..."
      brew upgrade --cask "$app" || true
    else
      echo "$app already installed as cask. Skipping."
    fi
    return
  fi

  echo "Trying to install $app as formula..."
  if brew install "$app"; then
    echo "Installed $app as formula."
  else
    echo "Formula install failed, trying as cask..."
    if brew install --cask "$app"; then
      echo "Installed $app as cask."
    else
      echo "Failed to install $app."
    fi
  fi
}

install_apps_mac() {
  echo "Installing apps: $apps"
  brew update
  for app in $apps; do
    install_app_brew "$app"
  done
}

# --- Oh My Zsh ---
install_oh_my_zsh() {
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
  fi

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "Oh My Zsh is already installed."
  fi
}

# --- macOS only ---
enable_touchid_for_sudo() {
  echo "Configuring Touch ID for sudo..."
  if ! grep -q "pam_tid.so" /etc/pam.d/sudo; then
    sudo sed -i '' '1s;^;auth       sufficient     pam_tid.so\n;' /etc/pam.d/sudo
    echo "✅ Touch ID for sudo is now enabled."
  else
    echo "Touch ID for sudo is already configured."
  fi
}

configure_macos_dock() {
  echo "Configuring macOS Dock..."

  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock orientation -string left
  defaults write com.apple.dock mineffect -string scale
  defaults write com.apple.dock largesize -int 36
  defaults write com.apple.dock show-recents -bool false

  killall Dock

  echo "✅ Dock configured."
}

# --- Main script ---
echo "==> Starting initial setup..."

install_jq
apps=$(jq -r '.apps[]' "$APP_LIST_FILE")

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  . /etc/os-release
  if [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"debian"* ]]; then
    echo "Detected Ubuntu/Debian"
    install_apps_linux
  else
    echo "Unsupported Linux distro: $ID"
    exit 1
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Detected macOS"
  enable_touchid_for_sudo
  configure_macos_dock
  install_apps_mac
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

install_oh_my_zsh

echo "✅ Initial setup complete!"

