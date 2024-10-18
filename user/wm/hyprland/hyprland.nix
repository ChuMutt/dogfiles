{ inputs, config, lib, pkgs, userSettings, systemSetting, ... }: {
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
}
