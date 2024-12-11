{ inputs, ... }@flakeContext:
let
  homeModule = { config, lib, pkgs, ... }: {
    config = {
      home = {
        homeDirectory = "/home/arya";
        packages = [
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
	  pkgs.lazygit
	  pkgs.lazydocker
	  pkgs.arandr
	  pkgs.vscode
	  pkgs.k9s
	  pkgs.spotify
	  pkgs.ollama
	  pkgs.keepassxc
	  pkgs.pamixer
        ];
        stateVersion = "24.11";
        username = "arya";
      };
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
    };
  };
  nixosModule = { ... }: {
    home-manager.users.arya = homeModule;
  };
in
(
  (
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        homeModule
      ];
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    }
  ) // { inherit nixosModule; }
)
