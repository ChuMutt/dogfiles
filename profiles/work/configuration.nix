# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  lib,
  systemSettings,
  userSettings,
  ...
}:
{
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/hardware/systemd.nix # systemd config
    ../../system/hardware/kernel.nix # Kernel config
    ../../system/hardware/power.nix # Power management
    ../../system/hardware/time.nix # Network time sync
    ../../system/hardware/opengl.nix
    ../../system/hardware/printing.nix
    ../../system/hardware/bluetooth.nix
    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix") # My window manager
    ../../system/app/flatpak.nix
    ../../system/app/virtualization.nix
    (import ../../system/app/docker.nix {
      storageDriver = null;
      inherit pkgs userSettings lib;
    })
    ../../system/security/sudo.nix
    ../../system/security/gpg.nix
    ../../system/security/blocklist.nix
    ../../system/security/firewall.nix
    ../../system/security/firejail.nix
    ../../system/security/openvpn.nix
    ../../system/security/automount.nix
    ../../system/style/stylix.nix
  ];

  # Fix nix path
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=$HOME/dotfiles/system/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.overlays = [
    (final: prev: {
      logseq = prev.logseq.overrideAttrs (oldAttrs: {
        postFixup = ''
          makeWrapper ${prev.electron_27}/bin/electron $out/bin/${oldAttrs.pname} \
            --set "LOCAL_GIT_DIRECTORY" ${prev.git} \
            --add-flags $out/share/${oldAttrs.pname}/resources/app \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
        '';
      });
    })
  ];

  # logseq
  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];

  # wheel group gets trusted access to nix daemon
  nix.settings.trusted-users = [ "@wheel" ];

  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;

  # Kernel modules
  boot.kernelModules = [
    "i2c-dev"
    "i2c-piix4"
    "cpufreq_powersave"
  ];

  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader.systemd-boot.enable = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.canTouchEfiVariables = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
  boot.loader.grub.enable = if (systemSettings.bootMode == "uefi") then false else true;
  boot.loader.grub.device = systemSettings.grubDevice; # does nothing if running uefi rather than bios

  # Networking
  networking.hostName = systemSettings.hostname; # Define your hostname.
  networking.networkmanager.enable = true; # Use networkmanager

  # Set your time zone.
  time.timeZone = systemSettings.timezone;
  # Select internationalisation properties.
  i18n =
    let
      l = systemSettings.locale;
    in
    {
      defaultLocale = l;
      extraLocaleSettings = {
        LC_ADDRESS = l;
        LC_IDENTIFICATION = l;
        LC_MEASUREMENT = l;
        LC_MONETARY = l;
        LC_NAME = l;
        LC_NUMERIC = l;
        LC_PAPER = l;
        LC_TELEPHONE = l;
        LC_TIME = l;
      };
    };

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "dialout"
      "video"
      "render"
    ];
    packages = [ ];
    uid = 1000;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    logseq
    wget
    zsh
    git
    cryptsetup
    home-manager
    wpa_supplicant
    spice-vdagent # Provides copy/paste support if this is a VM guest.

    # Shell script template (no shebang required):
    # (writeShellScriptBin "name" ''
    #
    # '')

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
    '')
    (writeShellScriptBin "chu-install-home-manager" ''
            # Installs the standalone version of Home Manager.
            # Step 1 of the configuration installation process following first
            # "nixos-rebuild switch --flake etc..." run (I think).

            # By default, Home Manager generates a configuration file and writes it
            # to ~/.config/home-manager/home.nix. Here, it'll go into $DOTFILES_DIR.

            # Add Home Manager channel to channel list:
            nix-channel --add \
              https://github.com/nix-community/home-manager/archive/master.tar.gz \
      	      home-manager

            # Pull channel updates from channel list:
            nix-channel --update

            # Generate a minimal Home Manager config at ~/.config/home-manager/home.nix
            nix run home-manager/master -- init --switch $DOTFILES_DIR

            # Flake inputs aren't updated by Home Manager, so we need to do it
            # ourselves:
            nix flake update

            # Install Home Manager via nix-shell.
            nix-shell '<home-manager>' -A install

            # Build and activate flake-based Home Manager configuration
            home-manager switch --flake $DOTFILES_DIR
    '')

    (writeShellScriptBin "chu-install-doom-emacs" ''
      git clone https://github.com/chumutt/doom ~/.config/doom
      git clone https://github.com/doomemacs/doomemacs --depth 1 ~/.config/emacs
      ./.config/emacs/bin/doom install
    '')

    (writeShellScriptBin "chu-install-roswell" ''
      ros install sbcl-bin
      ros use sbcl
      ros install sly
      ros install alexandria
      ros update quicklisp
    '')
    vesktop
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
      withTTS = true;
    })
    webcord
  ];

  # Enable the copy/paste support for virtual machines.
  services.spice-vdagentd.enable = true;
  services.seatd.enable = true;

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  fonts.fontDir.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  # It is ok to leave this unchanged for compatibility purposes
  system.stateVersion = "22.11";
}
