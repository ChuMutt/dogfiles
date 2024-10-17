{ config, pkgs, userSettings, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username; # TODO
  home.homeDirectory = "/home/" + userSettings.username; # TODO

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    (./. + "../../../user/wm" + ("/" + userSettings.wm + "/" + userSettings.wm) + ".nix")
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    zsh
    git
    rsync
    sshfs
    glib
    pass
    htop-vim
    coreutils
    direnv
    nix-direnv
    wireplumber pipewire
    yabridge yabridgectl # modern interface for windows vst2 & vst3 plugins
    openai-whisper-cpp # speech-to-text, dep. of emacspkg whisper.el
    mpd
    zfs
    shared-mime-info
    wine
    alacritty
    st
    konsole
    firefox
    # librewolf
    # qutebrowser
    # nyxt
    nextcloud-client
    ungit
    foliate # ebook reader
    # calibre # ebook reader
    zathura # pdf reader
    keepassxc # gui password/secret manager
    bottles # wine interface
    ## gui/audio
    audio-recorder
    raysession
    alsa-scarlett-gui # if you have a scarlett focusrite
    ardour
    tenacity
    calf
    mixxx
    musescore
    drumgizmo
    geonkick
    goattracker
    airwindows-lv2
    steam
    protonup
    discord
    telegram-desktop
    element
    roswell # lisp
    libreoffice-fresh
    gimp
    krita
    pinta
    inkscape
    libresprite
    # mypaint # TODO won't build
    xournalpp
    mpv
    yt-dlp
    gallery-dl
    # openscad
    obs-studio
    ffmpeg
    kdenlive
    mediainfo
    libmediainfo
    cheese
    movit
    libffi
    zlib
    ventoy
    looking-glass-client
    drumgizmo
    geonkick
    goattracker
    guitarix
    helvum
    jamesdsp
    jconvolver
    milkytracker
    mixxx
    musescore
    odin2
    paulstretch
    pavucontrol
    raysession
    reaper
    renoise
    roomeqwizard
    scream
    touchosc
    vcv-rack
    vorbis-tools
    wolf-shaper
    ffmpeg
    mpd
    mpv
    cheese
    kdenlive
    krita
    gimp
    inkscape
    nh
    xclip
    beets
    xdg-user-dirs
    discord
    telegram-desktop
    (pkgs.writeScriptBin "kdenlive-accel" ''
      #!/bin/sh
      DRI_PRIME=0 kdenlive "$1"
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/emacs/init.el".source = ../../user/emacs-profiles/chumacs/init.el;
    ".config/emacs/config.el".source = ../../user/emacs-profiles/chumacs/config.el;

  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
    };
    # Whether to manage {file}$XDG_CONFIG_HOME/user-dirs.dirs.
    # The generated file is read-only.
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      publicShare = null;
      music = "${config.home.homeDirectory}/Music";
      videos = "${config.home.homeDirectory}/Videos";
      pictures = "${config.home.homeDirectory}/Pictures";
      templates = "${config.home.homeDirectory}/Templates";
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      extraConfig = {
        XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dogfiles";
        XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
        XDG_ORG_DIR = "${config.home.homeDirectory}/nextcloud/documents/org";
        XDG_BOOK_DIR = "${config.home.homeDirectory}/Books";
      };
    };
  };

  # Whether to make programs use XDG directories whenever supported.
  home.preferXdgDirectories = true;

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/chu/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = {
    EDITOR = userSettings.editor; # TODO
    TERM = userSettings.term; # TODO
    BROWSER = userSettings.browser; # TODO
  };

  # GNU Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraPackages =
      epkgs: with epkgs; [
        nix-mode
        magit
        evil-collection
        command-log-mode
        doom-modeline
        all-the-icons
        doom-themes # optional
        which-key
        ivy-rich
        counsel
        rainbow-delimiters
      ];
  };

  services.emacs = {
    # Whether to enable the Emacs daemon
    client.enable = true;
    # Whether to enable systemd socket activation for the Emacs service daemon.
    socketActivation.enable = true;
    # Whether to launch Emacs service with the systemd user session.
    # If it is [set to] "graphical", Emacs service is started by graphical-session.target.
    startWithUserSession = "graphical";
  };

  # Neovim
  programs.neovim.enable = true;

  # Git
  programs.git = {
    enable = true;
    userEmail = "chufilthymutt@gmail.com";
    userName = "chu";
  };

  # TeX Live, used for TeX typesetting package distribution.
  programs.texlive = {
    enable = true;
  };

  # thefuck - magnificent app that corrects your previous console command.
  programs.thefuck = {
    enable = true;
  };

  # Thunderbird.
  programs.thunderbird = {
    enable = true;
    profiles."chu".isDefault = true; # TODO make this the generic user variable
  };

  # GnuPG private key agent.
  services.gpg-agent = {
    enable = true;
    # Set the time a cache entry is valid to the given number of seconds.
    defaultCacheTtl = 1800;
    # Whether to use the GnuPG key agent for SSH keys or not.
    enableSshSupport = true;
  };

  news.display = "silent"; # silence home manager news

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = if (config.stylix.polarity == "dark") then "Papirus-Dark" else "Papirus-Light";
  };

  services.pasystray.enable = true;

}
