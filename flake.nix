{
  description = "Chu the Pup's NixOS Flake";

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostname = "chunixos";
        profile = "work";
        timezone = "America/Chicago";
        locale = "en_US.UTF-8";
        boot = "uefi";
        bootPath = "/boot";
        grubDevice = "";
        gpuType = "nvidia";
      };
      userSettings = rec {
        username = "chu";
        name = "Chu";
        email = "chufilthymutt@gmail.com";
        dotfilesDir = "/home/chu/.dogfiles";
        theme = "io"; # TODO
        wm = "hyprland";
        wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
        browser = "firefox";
        defaultEmacsOrgDir = "~/nextcloud/documents/org";
        defaultEmacsOrgRoamDir = "roam"; # relative to "/org" (defaultEmacsOrgDir)
        term = "kitty";
        font = "Intel One Mono";
        fontPkg = pkgs.intel-one-mono;
        editor = "nvim";
      };

      pkgs = import inputs.nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      lib = inputs.nixpkgs.lib;

      home-manager = inputs.home-manager;

      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });

    in
    {
      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
            inputs.lix-module.nixosModules.default
          ];
          specialArgs = {
            inherit pkgs;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            # load home.nix from selected PROFILE
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit pkgs;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = self.packages.${system}.install;
          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git ]; # I could make this fancier by adding other deps
            text = ''${./install.sh} "$@"'';
          };
        }
      );
      apps = forAllSystems (system: {
        default = self.apps.${system}.install;
        install = {
          type = "app";
          program = "${self.packages.${system}.install}/bin/install";
        };
      });
    };
  inputs = {
    # Specify your NixOS version
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      # Specify your Home Manager version
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix"; # Themes
    blocklist-hosts = {
      # Adblock
      url = "github:StevenBlack/hosts";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/Hyprland.git";
      submodules = true;
      rev = "0f594732b063a90d44df8c5d402d658f27471dfe"; # v0.43.0
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
      rev = "b73d7b901d8cb1172dd25c7b7159f0242c625a77"; # v0.43.0
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      rev = "73b0fc26c0e2f6f82f9d9f5b02e660a958902763";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprgrass.url = "github:horriblename/hyprgrass/427690aec574fec75f5b7b800ac4a0b4c8e4b1d5";
    hyprgrass.inputs.hyprland.follows = "hyprland";
    nwg-dock-hyprland-pin-nixpkgs.url = "nixpkgs/2098d845d76f8a21ae4fe12ed7c7df49098d3f15";
  };
}
