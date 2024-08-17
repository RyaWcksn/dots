{
  description = "Home Manager configuration of Arya";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixgl, nixpkgs, home-manager, ... }@inputs:
  let
    username = "arya";
    linux_path = "/home/${username}";
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  in {
    homeConfigurations = {
      arya = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = allowUnfree;
            config.allowUnfreePredicate = allowUnfreePredicate;
            overlays = [nixgl.overlay];
          };
        extraSpecialArgs = { 
	  home = linux_path;
	  username = username;
          allowUnfree = allowUnfree;
          allowUnfreePredicate = allowUnfreePredicate;
	};
        modules = [ 
          ./home.nix
	];
      };
    };
  };
}
