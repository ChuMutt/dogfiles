{ config, ... }:
{
  home.file.".config/doom/themes/doom-stylix-theme.el".source = config.lib.stylix.colors {
    template = builtins.readFile ./themes/doom-stylix-theme.el.mustache;
    extension = ".el";
  };

  home.file.".local/share/random-splash-image-dir/chosen-splash-images/src/chu-the-pup-scene-queen-by-samariyuu.png" = {
    # TODO shorten
    source = ./../doom-emacs/res/chu-the-pup-scene-queen-by-samariyuu.png;
  };
}
