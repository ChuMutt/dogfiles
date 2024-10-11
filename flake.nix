{
  description = "Chu the Pup's NixOS Flake";

  inputs = {
    # Specify your NixOS version
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      # TODO prototype let statement
      systemSettings = {
        # TODO prototype(s)
        system = "x86_64-linux";
        hostname = "chunixos";
        # profile = "work";
        # timezone = "America/Chicago";
        # locale = "en_US.UTF-8";
        # boot = "uefi";
        # bootPath = "/boot";
        # grubDevice = "";
        # gpuType = "";
      };
      userSettings = rec {
        # TODO prototype(s)
        username = "chu";
        # TODO prototypes
        name = "Chu";
        email = "chufilthymutt@gmail.com";
        dotfilesDir = "~/.dogfiles";
        # theme = ""; 
        wm = "plasma";
        wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
        # browser = "firefox"; 
        # defaultEmacsOrgDir = "~/nextcloud/documents/org"; 
        # defaultEmacsOrgRoamDir = "roam"; # relative to "/org" (defaultEmacsOrgDir)
        # term = "konsole";
        # font = "Intel One Mono";
        # fontPkg = pkgs.intel-one-mono;
        # editor = "nvim"; # TODO neovide (maybe)
      };
      lib = inputs.nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        # hostname = nixpkgs.lib.nixosSystem { # TODO
        chunixos = nixpkgs.lib.nixosSystem {
          system = lib.nixosSystem { system = systemSettings.system; };
          modules = [ ./configuration.nix ];
        };
      };

      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./home.nix ];
        };
      };
    };
}
