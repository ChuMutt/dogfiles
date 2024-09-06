# flake.nix

{
  description = "nixOS config flake";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

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

    # blender-bin = {
    #   url = "github:edolstra/nix-warez?dir=blender";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Emacs
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      # temporary
      # ---------
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      systemSettings = {
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
        hostname = "chunix";
        profile = "chunix";
        timezone = "America/Chicago";
        locale = "en_US.UTF-8";
        bootMode = "uefi";
        bootMountPath =
          "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice =
          ""; # device identifier for grub; only used for legacy (bios) boot mode
        gpuType = "amd";
      };
      userSettings = rec {
        username = "chu";
        name = "Chu the Pup";
        email = "chufilthymutt@gmail.com";
        dotfilesDir = "~/.config/dogfiles";
        windowManager = "plasma";
        displayManager = "lightdm";
        browser = "firefox";
        defaultRoamDir = "~/nextcloud/documents/org/roam";
        term = "konsole";
        font = "Noto Sans";
        fontPkg = pkgs.noto-fonts;
        editor = "nvim";
        visual = "emacsclient";
        spawnEditor = if (editor == "emacsclient") then
          "emacsclient -c -a 'emacs'"
        else
          (if ((editor == "vim") || (editor == "nvim")
            || (editor == "nano")) then
            "exec " + term + " -e " + editor
          else
            editor);
      };
    in {
      homeConfigurations = {
        chu = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
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
    };
}
