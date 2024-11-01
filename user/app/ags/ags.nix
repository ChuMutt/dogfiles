{ config, ... }:

{
  home.file."${config.xdg.configHome}/ags" = {
    source = ./../../config/ags;
    recursive = true;
  };
}
