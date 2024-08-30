{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    startx.enable = lib.mkEnableOption "enables startx as display manager";
  };
  config = lib.mkIf config.startx.enable {
    services.xserver.displayManager.startx.enable = true;
  };
}
