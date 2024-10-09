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

    fortune
    hyfetch
    asciiquarium
    cowsay

    killall
    xdg-user-dirs
    htop-vim
    bottom

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

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Whether to manage {file}$XDG_CONFIG_HOME/user-dirs.dirs.
  # The generated file is read-only.
  xdg.userDirs = {
    enable = true; # Default is false.
    createDirectories = true; # Automatically create XDG directories if none exist.
  };

  # Whether to make programs use XDG directories whenever supported.
  home.preferXdgDirectories = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "gtk-overlay-scrollbars" = false;
    };
  };
  # Z-Shell
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      size = 10000000; # Number of history lines to keep
      save = 10000000; # Number of history lines to save
      path = "${config.xdg.cacheHome}/zsh/history";
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;
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
        # doom-themes
        which-key
        ivy-rich
        counsel
        rainbow-delimiters
      ];
    extraConfig = ''
            ;; Initialize vim keybindings
            (evil-mode)

            (setq inhibit-startup-message t ; Don't show a splash screen
              menu-bar-mode -1              ; Don't show a menu bar
              tool-bar-mode -1              ; Don't show a tool bar
              scroll-bar-mode -1            ; Don't show a scroll bar
              standard-indent 2             ; Set standard indentation to 2 spaces
              visible-bell t)               ; Set up visual flashing bell

            ;; Display line numbers in every buffer
            (global-display-line-numbers-mode 1)

            ;; Set frame fringe
            (set-fringe-mode 10)

            ;; Make escape key (ESC) kill prompts
            (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

            ;; Initialize package sources
            (require 'package)
            (setq package-archives '(("melpa" . "https://melpa.org/packages/")
      			                         ("org" . "https://orgmode.org/elpa/")
      			                         ("elpa" . "https://elpa.gnu.org/packages/")))
            (package-initialize)

            (unless package-archive-contents
              (package-refresh-contents))

            ;; Initialize use-package on non-Linux platforms
            (unless (package-installed-p 'use-package)
              (package-install 'use-package))

            (require 'use-package)

            (setq use-package-always-ensure t)

            ;; Start installing & configuring packages

            ;; Make UI more minimal
            (use-package command-log-mode)

            (use-package doom-modeline
              :ensure t
              :init (doom-modeline-mode 1)
              :custom ((doom-modeline-height 15)))

            (use-package all-the-icons)

            ;; (use-package doom-themes
            ;;   :init (load-theme 'doom-dracula t))

            ;; Load the Modus Vivendi dark theme
            (load-theme 'modus-vivendi t)

            (use-package rainbow-delimiters
              :hook (prog-mode . rainbow-delimiters-mode))

            (use-package which-key
              :init (which-key-mode)
              :diminish which-key-mode
              :config (setq which-key-idle-delay 1))

            (use-package ivy-rich
              :init (ivy-rich-mode 1))

	    (recentf-mode 1) ; remember recent file history

	    ;; Save what you enter into minibuffer prompts
	    (setq history-length 25)
            (savehist-mode 1)

	    ;; Remember and restore the last cursor location of opened files
	    (save-place-mode 1)

	    ;; Don't pop up UI dialogs when prompting
	    (setq use-dialog-box nil)

	    ;; Buffer auto-reversion
	    ;; Revert buffers when the underlying file has changed
            (global-auto-revert-mode 1)
	    ;; Revert Dired and other buffers
	    (setq global-auto-revert-non-file-buffers t)
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Neovim
  programs.neovim = {
    enable = true;
  };

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

}
