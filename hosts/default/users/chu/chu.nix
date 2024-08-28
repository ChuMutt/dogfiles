{ config, lib, pkgs, ... }:

{
  options = { chu.enable = lib.mkEnableOption "enable user module \"chu\"";
  chu.userName = lib.mkOption { default = "chu";
  description=''chu'';};};
  config = lib.mkIf config.chu.enable {
    users.users.${config.chu.userName} = {
      isNormalUser = true;
      initialPassword="qwerty";
      description = "chu";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      shell = pkgs.zsh;
    };
  };
}
