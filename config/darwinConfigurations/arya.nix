{ inputs, ... }@flakeContext:
let
  darwinModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.homeConfigurations.arya.nixosModule
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
    config = {
      security = {
        pam = {
          enableSudoTouchIdAuth = true;
        };
      };
      system = {
        defaults = {
          dock = {
            autohide = true;
            mru-spaces = false;
            orientation = "left";
          };
          loginwindow = {
            LoginwindowText = "Arya";
          };
        };
        stateVersion = 4;
      };
    };
  };
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    darwinModule
  ];
  system = "x86_64-darwin";
}
