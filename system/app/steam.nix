{ pkgs, ... }:
{
  hardware.opengl.driSupport32Bit = true;
  programs.steam.enable = true;
  environment = {
    systemPackages = [ pkgs.steam ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${XDG_DATA_DIR}/steam/root/compatibilitytools.d";
    };
  };
}
