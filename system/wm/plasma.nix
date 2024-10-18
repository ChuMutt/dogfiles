{ pkgs, ... }: {
  # Enable KDE Plasma 6 Desktop
  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs; [
    kate
    okular
    plasma-systemmonitor
  ];
}
