{ pkgs, ... }: {
  # imports = [ ../../modules/home-manager/default.nix ];
  home = {
    username = "chu";
    homeDirectory = "/home/chu";
    stateVersion = "24.05";
    packages = with pkgs; [
      # core
      zsh
      konsole
      firefox
      git

      # office
      nextcloud-client
      keepassxc
      xournalpp

      #media
      gimp
      krita
      pinta
      inkscape
      mpv
      yt-dlp
      gallery-dl
      libresprite
      openscad
      obs-studio
      ffmpeg
          (pkgs.writeScriptBin "kdenlive-accel" ''
      #!/bin/sh
      DRI_PRIME=0 kdenlive "$1"
    '')


    ];
  };
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = "chufilthymutt@gmail.com";
      userName = "chumutt";
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
      extraConfig = { push = { autoSetupRemote = true; }; };
    };
    zsh.enable = true;
    ssh.enable = true;
    gpg.enable = true;
    firefox.profiles.chu = {
      name = "chu";
      path = "chu";
      search = { default = "DuckDuckGo"; };
    };
  };
}
