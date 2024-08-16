{
  description = "Home Manager configuration of Arya";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    userSettings = {
      userName = "arya";
    };
    configuration = { pkgs, userSettings, ... }: {
      hardware.opengl.driSupport32Bit = true;
      nixpkgs.config = {
        allowUnfree = true;
      };
      environment.systemPackages = [
      ];
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # default shell on catalina
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      security.pam.enableSudoTouchIdAuth = true;
    };
  in {
    homeConfigurations = {
      arya = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit userSettings; inherit configuration; };
      };
    };
  };
}
