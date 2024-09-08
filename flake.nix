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
    nixos-hardware.url = "github:nixos/nixos-hardware";
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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      systemSettings = {
        system = "x86_64-linux";
        hostname = "chunixos-vm";
        profile = "work";
        timezone = "America/Chicago";
        locale = "en_US.UTF-8";
        bootMode = "uefi"; # uefi or bios
        bootMountPath =
          "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice =
          ""; # device identifier for grub; only used for legacy (bios) boot mode
        gpuType = "vm"; # amd, intel, nvidia, or vm.
      };
      userSettings = rec {
        username = "chu";
        name = "chu the pup";
        email = "chufilthymutt@gmail.com";
        dotfilesDir = "~/.config/dogfiles";
        theme = null;
        wm = null;
        wmType = "x11";
        browser = "firefox";
        term = "konsole";
        font = "Noto Sans";
        fontPkg = pkgs.noto-fonts;
        editor = "emacsclient";
        # editor spawning translator
        # generates a command that can be used to spawn editor inside a gui
        # EDITOR and TERM session variables must be set in home.nix or other module
        # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
        spawnEditor = if (editor == "emacsclient") then
          "emacsclient -c -a 'emacs'"
        else
          (if ((editor == "vim") || (editor == "nvim")
            || (editor == "nano")) then
            "exec " + term + " -e " + editor
          else
            editor);
      };
      # create patched nixpkgs
      # nixpkgs-patched = (import inputs.nixpkgs {
      #   system = systemSettings.system;
      #   rocmSupport = (if systemSettings.gpu == "amd" then true else false);
      # }).applyPatches {
      #   name = "nixpkgs-patched";
      #   src = inputs.nixpkgs;
      # patches = [ ./patches/example.patch ];
      # };

    in {
      homeConfigurations = {
        chu = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./profiles/work/home.nix ];
        };
      };
      nixosConfigurations = {
        chunixos-vm = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./profiles/work/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
