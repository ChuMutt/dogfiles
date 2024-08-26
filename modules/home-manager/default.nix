{ config, lib, pkgs, ... }:

{
  imports = [
    ./browsers/default.nix
    ./editors/default.nix
    ./filemanagers/default.nix
    ./vc/default.nix
    ./tty/default.nix
  ];
}
