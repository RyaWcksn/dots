{
  description = "Configuration of my laptops";
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
  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      darwinConfigurations = {
        arya = import ./darwinConfigurations/arya.nix flakeContext;
      };
      homeConfigurations = {
        arya = import ./homeConfigurations/arya.nix flakeContext;
      };
    };
}
