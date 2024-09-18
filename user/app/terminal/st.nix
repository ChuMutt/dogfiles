{ pkgs, lib, ... }: {
  home.packages = with pkgs; [ st ];
  programs.st = {
    enable = true;
  };
}
