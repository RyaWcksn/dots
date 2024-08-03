{ config, pkgs, ... }:

{
  home.username = "arya";
  home.homeDirectory = "/home/arya";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pkgs.neovim
    pkgs.git
    htop
    pkgs.neofetch
    ncmpcpp
    rofi
    dunst
    mpd
    mpv
    stow
    bspwm
    tmux
    zathura
    polybar
    xbacklight
    playerctl
  ];

  services = {
    ssh-agent = {
      enable = true;
      forwarding = true;
    };
  };
  programs.git = {
	  enable = true;
	  userEmail = "pram.aryawcksn@gmail.com";
	  userName = "RyaWcksn";
  };
}
