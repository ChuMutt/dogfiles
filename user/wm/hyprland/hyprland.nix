{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default
    ];
    xwayland = { enable = true; };
    systemd.enable = true;
  };
}
