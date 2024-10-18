{ inputs, pkgs, ... }:
let
  pkgs-hyprland =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # req'd for standalone HM

  # Import wayland config
  imports = [
    ./wayland.nix
    # ./pipewire.nix
    # ./dbus.nix
  ];

  # Security
  security = { pam.services.login.enableGnomeKeyring = true; };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland = { enable = true; };
      portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
    };
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  services.xserver = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
      package = pkgs.sddm;
    };
  };
}
