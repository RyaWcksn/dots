{
  description = "Home Manager configuration of Arya";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    configuration = { pkgs, ... }: {
      nixpkgs.config = {
        allowUnfree = true;
      };
      environment.systemPackages = [
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
      ];
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # default shell on catalina
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nix.configureBuildUsers = true;
      nix.useDaemon = true;
    };
  in {
    homeConfigurations.arya = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
    };
  };
}
