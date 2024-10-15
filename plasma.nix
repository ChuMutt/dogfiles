{ config, pkgs, userSettings, ... }:
{
  # Enable KDE Plasma 6 Desktop
  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };
}
