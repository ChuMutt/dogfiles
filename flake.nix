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
      # TODO prototype let statement
      systemSettings = {
        # TODO prototype(s)
        system = "x86_64-linux";
        hostname = "chunixos";
        profile = "work";
        timezone = "America/Chicago";
        locale = "en_US.UTF-8";
        boot = "uefi";
        bootPath = "/boot";
        grubDevice = "";
        gpuType = "";
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
        browser = "firefox";
        defaultEmacsOrgDir = "~/nextcloud/documents/org";
        defaultEmacsOrgRoamDir = "roam"; # relative to "/org" (defaultEmacsOrgDir)
        term = "konsole";
        font = "Intel One Mono";
        fontPkg = nixpkgs.intel-one-mono;
        editor = "nvim"; # TODO neovide (maybe)
      };
      lib = inputs.nixpkgs.lib;

      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });

    in
    {
      nixosConfigurations = {
        # hostname = nixpkgs.lib.nixosSystem { # TODO
        chunixos = nixpkgs.lib.nixosSystem {
          system = lib.nixosSystem { system = systemSettings.system; };
          modules = [ ./configuration.nix ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      homeConfigurations = {
        chu = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
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

  };
}
