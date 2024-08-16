{ userSettings, config, pkgs, system, ... }:

{
  nixpkgs.config = {allowUnfree = true;};
  home.username = "${userSettings.userName}";
  home.homeDirectory = "/home/${userSettings.userName}";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.packages = [
	pkgs.neovim
        pkgs.git
        pkgs.htop
        pkgs.neofetch
        pkgs.ncmpcpp
        pkgs.rofi
        pkgs.dunst
        pkgs.mpd
        pkgs.mpv
        pkgs.stow
        pkgs.bspwm
        pkgs.tmux
        pkgs.zathura
        pkgs.polybar
        pkgs.playerctl
        pkgs.jq
        pkgs.tree
        pkgs.atac
        pkgs.termshark
	pkgs.wireshark
	pkgs.xorg.xbacklight
	pkgs.nixd
	pkgs.android-tools
	pkgs.alacritty
	pkgs.zsh
	pkgs.google-chrome
	pkgs.kitty
	pkgs.postman
	pkgs.emacs
	pkgs.mesa
  ];
}
