{ pkgs, config, ... }:

{
  # GNU Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    # extraPackages = epkgs:
    #   with epkgs; [
    #     nix-mode
    #     magit
    #     evil-collection
    #     command-log-mode
    #     doom-modeline
    #     all-the-icons
    #     doom-themes # optional
    #     which-key
    #     ivy-rich
    #     counsel
    #     rainbow-delimiters
    #   ];
  };

  home.file."${config.xdg.configHome}/chumacs" = {
    source = ./../../config/chumacs;
    recursive = true;
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

}
