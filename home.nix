{ config, pkgs, ... }: {
  imports = [ ./shells.nix ]; # Do not rename to shell.nix: filename reserved.
  home.username = "chu";
  home.homeDirectory = "/home/chu";
  # You should not change this value, even if you update Home Manager.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    bc
    rsync
    ffmpeg
    yt-dlp
    # indexing / search dependencies (deps) for emacs
    fd
    (ripgrep.override { withPCRE2 = true; })
    # emacs deps
    emacs-all-the-icons-fonts
    nixfmt-rfc-style # :lang nix

    # fonts
    fontconfig
    (nerdfonts.override { fonts = [ "FiraCode" ]; }) # doom emacs default font

  ];

  # Autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true;

  home.file = { };

  home.sessionVariables = {
    EDITOR = "neovim";
    TERMINAL = "st";
    TERMINAL_PROG = "st";
    VISUAL = "emacs";
    BROWSER = "librewolf";
    # Doom Emacs
    DOOMDIR = "${config.xdg.configHome}/doom";
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
    DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
  };

  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  # Note! This must match $DOOMDIR
  # xdg.configFile."doom".source = ./doom;

  # Note! This must match $EMACSDIR
  xdg.configFile."emacs".source = builtins.fetchGit {
    url = "https://github.com/doomemacs/doomemacs.git";
    rev = "03d692f129633e3bf0bd100d91b3ebf3f77db6d1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable Emacs, choose package.
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacs29;
  # Run de-bootstrap.sh

  programs.git = {
    enable = true;
    userName = "chumutt";
    userEmail = "chufilthymutt@gmail.com";
    extraConfig = { init.defaultBranch = "main"; };
  };
}
