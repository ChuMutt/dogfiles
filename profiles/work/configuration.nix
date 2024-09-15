# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, inputs, systemSettings, userSettings, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ../../system/hardware-configuration.nix
    ../../system/hardware/systemd.nix
    ../../system/hardware/time.nix
    ../../system/hardware/kernel.nix
    ../../system/hardware/power.nix
    ../../system/hardware/opengl.nix
    ../../system/hardware/printing.nix
    ../../system/hardware/bluetooth.nix
    # (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix")
    ../../system/wm/x11.nix # TODO fix
    ../../system/app/vm.nix
    ../../system/app/nh.nix
    ../../system/security/gpg.nix
    ../../system/security/sshd.nix
    ../../system/security/proxy.nix
    ../../system/security/firewall.nix
    # TODO ../../system/security/automount.nix
  ];

  # Fix nix path
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    ("nixos-config=" + userSettings.dotfilesDir + "/system/configuration.nix")
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # wheel group gets trusted access to nix daemon
  nix.settings.trusted-users = [ "@wheel" ];

  # Allow unfree packages. Sorry, rms.
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable =
        if (systemSettings.bootMode == "uefi") then true else false;
      efi.canTouchEfiVariables =
        if (systemSettings.bootMode == "uefi") then true else false;
      efi.efiSysMountPoint =
        systemSettings.bootMountPath; # does nothing if running bios rather than uefi
      grub.enable = if (systemSettings.bootMode == "uefi") then false else true;
      grub.device =
        systemSettings.grubDevice; # does nothing if running uefi rather than bios
    };
    kernelModules = [ "i2c-dev" "i2c-piix4" "cpufreq_powersave" ];
    # initrd.luks.devices."luks-c233bfdc-56f5-4381-982a-3e17a746e0da".device =
    #   "/dev/disk/by-uuid/c233bfdc-56f5-4381-982a-3e17a746e0da"; # TODO
  };

  networking = {
    hostName = systemSettings.hostname; # Define your hostname.
    networkmanager.enable = true; # Enable networking
  };

  # Timezone and locale
  time.timeZone = systemSettings.timezone; # time zone
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups =
      [ "networkmanager" "wheel" "input" "dialout" "video" "render" ];
    packages = [ ];
    uid = 1000;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # or
  # $ nh search wget
  environment = {
    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      zsh
      git
      cryptsetup
      home-manager
      wpa_supplicant

      # scripts
      (pkgs.writeScriptBin "comma" ''
        if [ "$#" = 0 ]; then
          echo "usage: comma PKGNAME... [EXECUTABLE]";
        elif [ "$#" = 1 ]; then
          nix-shell -p $1 --run $1;
        elif [ "$#" = 2 ]; then
          nix-shell -p $1 --run $2;
        else
          echo "error: too many arguments";
          echo "usage: comma PKGNAME... [EXECUTABLE]";
        fi
      '') # by librephoenix

      tldr
      neovim
      htop
      ((emacsPackagesFor emacs-gtk).emacsWithPackages (epkgs: [ epkgs.vterm ]))
      protonup # imperative bootstrap for proton-ge

      # custom scripts
      # TODO fix this script because it doesn't work
      (writeShellScriptBin "chu-install-home-manager-unstable" ''
              # doesn't work currently
                # home-manager is recommended for this setup
                # this installs the standalone version (recommended)
                nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager &&
                nix-channel --update &&
                nix-shell '<home-manager>' -A install
        	# then run home-manager switch --flake ~/.config/dogfiles/#dogleash
      '')
      (writeShellScriptBin "chu-install-doom-emacs" ''
        git clone https://github.com/chumutt/doom ~/.config/doom
        git clone https://github.com/doomemacs/doomemacs --depth 1 ~/.config/emacs
        ./.config/emacs/bin/doom install
      '')
    ];

    shells = with pkgs; [ zsh ];

  };

  programs = {
    zsh.enable = true;
    nh.enable = true;
  };

  fonts.fontDir.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal xdg-desktop-portal-gtk ];
  };

  # List services that you want to enable:
  services = {
    # Make Emacs packages available to the Emacs Daemon (emacsclient).
    emacs.package = with pkgs;
      ((emacsPackagesFor emacs-gtk).emacsWithPackages
        (epkgs: [ epkgs."vterm" ]));
  };

  # Add emacs overlay
  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
  # TODO Move?

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
