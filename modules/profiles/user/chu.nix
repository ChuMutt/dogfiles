{ config, lib, pkgs, ... }:

let cfg = config.chu;
in {
  options.chu = {
    enable = lib.mkEnableOption ''enable user module "chu"'';
    userName = lib.mkOption {
      default = "chu";
      description = "chu";
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      initialPassword = "qwerty";
      description = "chu";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      shell = pkgs.zsh;
    };
  };
}
