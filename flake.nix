# flake.nix

{
  description = "nixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Agenix
    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO: Declarative partitions
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    blender-bin = {
      url = "github:edolstra/nix-warez?dir=blender";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {

        chunix = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/chunix/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        chunixos-vm = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/chunixos-vm/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        dogleash = lib.nixosSystem {
          specialArgs = { inherit inputs; };
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
