{ config, pkgs, ... }: {
  imports = [ ./shells.nix ]; # Do not rename to shell.nix: filename reserved.
  home = {
    username = "chu";
    homeDirectory = "/home/chu";
    stateVersion = "24.05"; # Please read the comment before changing.

    packages = with pkgs; [
      cachix
      bc
      rsync
      ffmpeg
      yt-dlp
      fd
      (ripgrep.override { withPCRE2 = true; })
      emacs-all-the-icons-fonts
      nixfmt-rfc-style # :lang nix
      fontconfig
      (nerdfonts.override { fonts = [ "FiraCode" ]; }) # doom emacs default font
    ];

    file = { };
    sessionVariables = {
      EDITOR = "neovim";
      TERMINAL = "st";
      TERMINAL_PROG = "st";
      VISUAL = "emacs";
      BROWSER = "librewolf";
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
    };

    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    emacs = {
      package = pkgs.emacs29;
      enable = true;
    };

    git = {
      enable = true;
      userName = "chumutt";
      userEmail = "chufilthymutt@gmail.com";
      extraConfig = { init.defaultBranch = "main"; };
    };
  };

  # Note! This must match $DOOMDIR
  # Comment this out prior to running `doom install`
  xdg.configFile."doom".source = ./doom;
  # Uncomment after install, sync, and first run. Then:
  # 1. cd ~/.dotfiles
  # 2. mv $DOOMDIR .
  # 3. git add doom
  # 4. home-manager switch --flake .
  # Then doom will reside in your dotfiles like a good imp.

  # Autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true;

  # Note! This must match $EMACSDIR
  xdg.configFile."emacs".source = builtins.fetchGit {
    url = "https://github.com/doomemacs/doomemacs.git";
    rev = "03d692f129633e3bf0bd100d91b3ebf3f77db6d1";
  };
}
