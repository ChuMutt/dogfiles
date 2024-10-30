{ pkgs-stable, ... }:
{
  fonts.packages = with pkgs-stable; [
    nerdfonts
    powerline
  ];
}
