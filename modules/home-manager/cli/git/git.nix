{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    git.enable = lib.mkEnableOption "enables git";
  };
  config = lib.mkIf config.git.enable { programs.git.enable = true; };
}
