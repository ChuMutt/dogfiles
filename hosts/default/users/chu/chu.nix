{ config, lib, pkgs, ... }:

{
  options = { };
  config = {
    users.users.chu = {
      isNormalUser = true;
      description = "chu";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
  };
}
