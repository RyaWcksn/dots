{ inputs, ... }@flakeContext:
let
  homeModule = { config, lib, pkgs, ... }: {
    config = {
      home = {
        homeDirectory = "/home/aya";
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
	  pkgs.nixd
	  pkgs.alacritty
	  pkgs.zsh
	  pkgs.kitty
	  pkgs.aria2
	  pkgs.lazygit
	  pkgs.lazydocker
	  pkgs.vscode
	  pkgs.k9s
	  pkgs.spotify
	  pkgs.keepassxc
	  pkgs.trivy
	  pkgs.neomutt
	  pkgs.sonar-scanner-cli
	  pkgs.ninja
	  pkgs.fzf
	  pkgs.ntfy
	  pkgs.gnome-tweaks
	  pkgs.dbeaver-bin
	  pkgs.unrar
	  pkgs.zip
        ];
        stateVersion = "24.11";
        username = "aya";
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
