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
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.xdg-user-dirs
    pkgs.htop-vim
    pkgs.bottom
    pkgs.fortune
    pkgs.hyfetch
    pkgs.asciiquarium
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

  xdg.userDirs = {
    enable = true;
    createDirectories =
      true; # Automatically creates (and will replace) XDG directories if not extant.
  };

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
  programs.emacs = { enable = true; };

  # nvim
  programs.neovim = { enable = true; };

  # Git
  programs.git = {
    enable = true;
    userEmail = "chufilthymutt@gmail.com";
    userName = "chu";
  };
}
