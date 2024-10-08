{ inputs, pkgs, lib, config, ... }@flakeContext:

let
in 
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  home.username = "arya";
  home.homeDirectory = "/home/arya";
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
	pkgs.aria2
	pkgs.keepassxc
  ];
}
