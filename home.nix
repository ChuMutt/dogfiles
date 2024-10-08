{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "chu";
  home.homeDirectory = "/home/chu";

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
    xdg-user-dirs
    htop-vim
    bottom
    fortune
    hyfetch
    asciiquarium
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
  };

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

  home.sessionVariables = { EDITOR = "nvim"; };

  # Whether to manage {file}$XDG_CONFIG_HOME/user-dirs.dirs.
  # The generated file is read-only.
  xdg.userDirs = {
    enable = true; # Default is false.
    createDirectories =
      true; # Automatically create XDG directories if none exist.
  };

  # Whether to make programs use XDG directories whenever supported.
  home.preferXdgDirectories = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Z-Shell
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = "$HOME/.config/zsh";
    history = {
      size = 10000000; # Number of history lines to keep
      save = 10000000; # Number of history lines to save
      path = "$HOME/.cache/zsh/history";
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;
  };

  # GNU Emacs
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [ nix-mode magit evil-collection ];
    extraConfig = ''
      (setq standard-indent 2)
    '';
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
  programs.neovim = { enable = true; };

  # Git
  programs.git = {
    enable = true;
    userEmail = "chufilthymutt@gmail.com";
    userName = "chu";
  };

  # TeX Live, used for TeX typesetting package distribution.
  programs.texlive = { enable = true; };

  # thefuck - magnificent app that corrects your previous console command.
  programs.thefuck = { enable = true; };

  # Thunderbird.
  programs.thunderbird = {
    enable = true;
    profiles."chu".name = "chu";
  };

  # GnuPG private key agent.
  services.gpg-agent = {
    enable = true;
    # Set the time a cache entry is valid to the given number of seconds.
    defaultCacheTtl = 1800;
    # Whether to use the GnuPG key agent for SSH keys or not.
    enableSshSupport = true;
  };

}
