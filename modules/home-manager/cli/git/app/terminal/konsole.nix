{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [ kdePackages.konsole ];
  programs.kdePackages.konsole.enable = true;
  programs.kdePackages.konsole.settings = {
    window.opacity = lib.mkForce 0.85;
  };
}
