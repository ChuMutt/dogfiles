{ config, ... }:

{
  home.file."${config.xdg.configHome}/chumacs" = {
    source = ./../../config/chumacs;
    recursive = true;
  };
}
