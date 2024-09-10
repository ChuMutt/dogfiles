{ config, pkgs, ... }: {

  home = {
    packages = with pkgs; [ lf ueberzugpp ];
    file = {
      ".config/lf/lfrc".source = ./lfrc;
      ".config/lf/scope".source = ./scope;
      ".config/lf/icons".source = ./icons;
      ".config/lf/cleaner".source = ./cleaner;
    };
  };
}
