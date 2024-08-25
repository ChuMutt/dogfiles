{
  description = "chunixOS";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Secrets mgmt.
    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO: Declarative partitions
    # disko.url = "github:nix-community/disko";
    # disko.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

# Pass flake inputs to external config files:
  outputs = inputs@{ self, nixpkgs, nixos-hardware, ... }:
    let
      args = {
        inherit self;
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs { };
      };
      lib = import ./lib args;
    in with builtins;
    with lib;
    mkFlake inputs {
      systems = [ "x86_64-linux" ];
      inherit lib;

      hosts = mapHosts ./hosts;
      modules.default = import ./.;

      apps.install = mkApp ./install.zsh;
      # devShells.default = import ./shell.nix;
      # checks = mapModules ./test import;
      # overlays = mapModules ./overlays import;
      # packages = mapModules ./packages import;
      # templates = import ./templates args;
    };
}
