{ config, lib, pkgs, ... }:

{
  users.users.chu = {
    isNormalUser = true;
    description = "chu";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
