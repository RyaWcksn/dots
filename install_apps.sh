#!/bin/bash

set -e

APP_LIST_FILE="apps.json"

UPDATE_APPS=false

if [[ "$1" == "--update" ]]; then
  UPDATE_APPS=true
fi


# Check for jq, install if missing
install_jq() {
  if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      sudo apt update && sudo apt install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

install_apps_linux() {
  echo "Installing apps: $apps"
  sudo apt update
  sudo apt install -y $apps
}

install_app_mac() {
  local app=$1

  if brew list --formula | grep -qx "$app"; then
    echo "$app is already installed as formula."
    return
  fi

  if brew list --cask | grep -qx "$app"; then
    echo "$app is already installed as cask."
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
      echo "Failed to install $app as formula or cask."
    fi
  fi
}

install_app_mac() {
  local app=$1
  local capitalized_app="$(tr '[:lower:]' '[:upper:]' <<< ${app:0:1})${app:1}"

  if [[ -d "/Applications/$capitalized_app.app" && "$UPDATE_APPS" = false ]]; then
    echo "$capitalized_app.app exists in /Applications. Skipping."
    return
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
    install_app_mac "$app"
  done
}

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

  echo "✅ Dock autohide enabled, moved left, scale effect set, smaller minimize size, and recent apps hidden."
}

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

