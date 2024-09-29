{ pkgs, ... }:
{
  services = {
    displayManager = {
      sddm.enable = true;
    };
    desktopManager = {
      plasma6 = {
        enable = true;
        # configFile = {
        #   "kwinrc"."NightColor"."Active" = true;
        #   "kwinrc"."NightColor"."Mode" = "Location";
        #   "kwinrc"."NightColor"."NightTemperature" = 5800;
        # };
      };
    };
  };
}
