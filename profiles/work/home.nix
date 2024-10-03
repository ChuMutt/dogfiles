{ config, pkgs, userSettings, ... }: {
  imports = [
    ../../user/shell/sh.nix
    ../../user/app/lf/lf.nix
    ../../user/app/git/git.nix
    ../../user/app/vm/vm.nix
    ../../user/lang/cc/cc.nix
    ../../user/lang/lisp/lisp.nix
    ../../user/lang/rust/rust.nix
    ../../user/hardware/bluetooth.nix
    ../../user/app/keepass/keepass.nix
  ];

  home = {
    username = userSettings.username;
    homeDirectory = "/home/" + userSettings.username;
    stateVersion = "24.05"; # Do not modify.
    packages = with pkgs; [
      # core
      zsh
      konsole
      librewolf
      git
      # office
      nextcloud-client
      libreoffice-fresh
      keepassxc
      xournalpp
      kdePackages.kate
      # media
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
      mediainfo
      libmediainfo
      audio-recorder
      cheese
      raysession
      ardour
      rosegarden
      tenacity
      calf
      # Various dev packages
      sshfs
      texinfo
      libffi
      zlib
      nodePackages.ungit
      nixfmt-rfc-style
      ventoy
      kdePackages.kdenlive
      discord
      telegram-desktop
      exercism
    ];
  };

  home.file.".local/share/roswell/helper.el".source =
    ../../user/lang/lisp/roswell/helper.el;
  home.file.".config/nixpkgs/config.nix".source = ../../user/nixpkgs/config.nix;
  home.file.".local/share/random-splash-image-dir/chosen-splash-images/src/chu-the-pup-scene-queen-by-samariyuu.png".source =
    ../../res/chu-the-pup-scene-queen-by-samariyuu.png;

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = userSettings.email;
      userName = userSettings.name;
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
    firefox.enable = true;
    firefox.profiles.chu = {
      name = userSettings.username;
      path = userSettings.username;
      search = { default = "DuckDuckGo"; };
    };
  };

  services = {
    nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };

  xdg = {
    enable = true;
    userDirs = { enable = true; };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.libsForQt5.breeze-gtk;
    };
  };
  # gtk3 = { extraConfig.gtk-application-prefer-dark-theme = true; };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Breeze-Dark";
      color-scheme = "prefer-dark";
    };
  };
  # hardware.opentabletdriver.enable = true;
  # hardware.opentabletdriver.daemon.enable = true;
}
