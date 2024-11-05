{ config, ... }:
{
  home.file.".config/doom/themes/doom-stylix-theme.el".source = config.lib.stylix.colors {
    template = builtins.readFile ./themes/doom-stylix-theme.el.mustache;
    extension = ".el";
  };

  home.file.".local/share/random-splash-images/chu-the-pup-scene-queen-by-samariyuu.png" = {
    source = ./res/chu-the-pup-scene-queen-by-samariyuu.png;
  };
}
