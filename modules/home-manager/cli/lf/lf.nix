{ config, lib, ... }: {
  options = { lf.enable = lib.mkEnableOption "enables lf"; };
  config = lib.mkIf config.lf.enable { lf.enable = true; };
}
