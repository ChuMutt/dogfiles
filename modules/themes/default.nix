# (mkIf (cfg.wallpaper != null)
# Set the wallpaper ourselves so we don't need .background-image and/or
# .fehbg polluting $HOME
(let
  wCfg = config.services.xserver.desktopManager.wallpaper;
  command = ''
    if [ -e "$DOTFILES_HOME/modules/themes/default/bg" ]; then
      # ${pkgs.feh}/bin/feh --bg-${wCfg.mode} \
        # ${optionalString wCfg.combineScreens "--no-xinerama"} \
        # --no-fehbg \
        # xwallpaper --fill $XDG_DATA_HOME/bg #*
        xwallpaper --fill $DOTFILES_HOME/modules/themes/default/bg #*
    fi
  '';
in {
  services.xserver.displayManager.sessionCommands = command;
  hooks.reload."10-wallpaper" = command;
})
# )
