{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    neovim.enable = lib.mkEnableOption "enables neovim";
  };
  config = lib.mkIf config.neovim.enable { programs.neovim.enable = true; };
}
