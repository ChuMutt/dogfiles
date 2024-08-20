{ config, pkgs, ... }: {
  imports = [ ./shells.nix ]; # Do not rename to shell.nix: filename reserved.
  home = {
    username = "chu";
    homeDirectory = "/home/chu";
    stateVersion = "24.05"; # Please read the comment before changing.

    packages = with pkgs; [
      cachix
      zsh
      tldr
      bc
      rsync
      ffmpeg
      yt-dlp
      fontconfig
      dmenu
      (dwmblocks.overrideAttrs { src = pkgs.fetchFromGitHub {
                                   owner = "chumutt";
                                   repo = "dwmblocks";
                                   rev = "main";
                                   sha256 = "KTW2fUWiWJjyHbpEbnaEq3wcuncn4fM5xk1o8CpEdOE=";
                                 };
                               }) # TODO add missing sb-* scripts
      st

      fd
      (ripgrep.override { withPCRE2 = true; })
      nixfmt-rfc-style # :lang nix
      emacs-all-the-icons-fonts
      (nerdfonts.override { fonts = [ "FiraCode" ]; }) # doom emacs default font
      cmake

    ];

    file = { ".xinitrc".source = ./x11/xinitrc; };

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
    zsh.enable = true;
    # Emacs
    emacs = {
      enable = true;
      package = pkgs.emacs29;
    };

    git = {
      enable = true;
      userName = "chumutt";
      userEmail = "chufilthymutt@gmail.com";
      extraConfig = { init.defaultBranch = "main"; };
    };
  };

  # Note! This must match $EMACSDIR
  xdg.configFile."emacs".source = builtins.fetchGit {
    url = "https://github.com/doomemacs/doomemacs.git";
    rev = "03d692f129633e3bf0bd100d91b3ebf3f77db6d1";
  };

  xdg.configFile."doom".source = ./doom;

  # services.emacs.enable = true; # emacs daemon / server mode # Disabled for testing installation

  # Autoload fonts from packages installed via Home Manager
  # fonts.fontconfig.enable = true;



}
