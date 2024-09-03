{ specialArgs, pkgs, lib, config, ... }:

let
  nixGLVulkanMesaWrap = pkg:
    pkgs.runCommand "${pkg.name}-nixgl-wrapper" { } ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
       wrapped_bin=$out/bin/$(basename $bin)
       echo "${lib.getExe pkgs.nixgl.nixGLIntel} ${
         lib.getExe pkgs.nixgl.nixVulkanIntel
       } $bin \$@" > $wrapped_bin
       chmod +x $wrapped_bin
      done
    '';
in 
{
  nixpkgs = {
    config = {
      allowUnfree = specialArgs.allowUnfree or false;
      allowUnfreePredicate = specialArgs.allowUnfreePredicate or (x: false);
      permittedInsecurePackages = [ "electron-12.2.3" "electron-19.1.9" ];
    };
  };
  home.username = specialArgs.username;
  home.homeDirectory = specialArgs.home;
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
