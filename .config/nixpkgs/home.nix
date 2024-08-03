{ config, pkgs, ... }:

{
  home.username = "arya";
  home.homeDirectory = "/home/arya";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    dejavu_fonts
    liberation_ttf
    neovim
    git
    htop
    neofetch
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
    playerctl
    jq
    tree
  ];
  fonts.fontconfig.enable = true;
  i18n = {
	  inputMethod = {
		  enabled = "fcitx5";
		  fcitx5.addons = [ pkgs.fcitx5-mozc ];
	  };
  };
  services.fcitx5 = {
	  enable = true;
	  startAtStartup = true;
  };

  services = {
    ssh-agent = {
      enable = true;
    };
  };
  programs.git = {
	  enable = true;
	  userEmail = "pram.aryawcksn@gmail.com";
	  userName = "RyaWcksn";
  };
  home.sessionVariables = {
	  EDITOR = "nvim";
  };
}
