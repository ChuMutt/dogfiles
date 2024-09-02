# flake.nix

{
  description = "nixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        chunixos-vm = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/chunixos-vm/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        dogleash = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/dogleash/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
      homeConfigurations = {
        chu = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };


    };
}
