# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, lib, pkgs, callPackage, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix # hardware config
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = { layout = "us"; };

  # services.emacs.package = pkgs.emacs-unstable;
  services.emacs.enable = true; # emacs daemon / server mode

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chu = {
    isNormalUser = true;
    description = "chu";
    extraGroups = [ "networkmanager" "wheel" ];
    # open.ssh.authorizedKeys.keys = [ "ssh-dss AAAB3Nza... user@blahblah" ];
    # packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    killall
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "chu" ];

  # Zsh; which needs to be enabled in your home.nix.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # X11
  services.xserver = {
    enable = true;
    windowManager = {
      dwm.package = pkgs.dwm.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "chumutt";
          repo = "dwm";
          rev = "main";
          sha256 = "P9ecPUWfdwW1MYFzWTifxIJyTZQDFCkfoV3HVheRte8=";
        };
      };
      dwm.enable = true;
    };
    autorun = false;
    displayManager.startx.enable = true; # use startx command to start x server
  };
  # X11 compositor
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };
}
