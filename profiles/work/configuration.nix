# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, systemSettings, userSettings, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ../../system/hardware-configuration.nix
    (./. + "../../../system/wm" + ("/" + userSettings.wm)
      + ".nix") # My window manager
  ];

  nix = {
    # Fix nix path
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      ("nixos-config=" + userSettings.dotfilesDir + "/system/configuration.nix")
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    # Ensure nix flakes are enabled
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # wheel group gets trusted access to nix daemon
      trusted-users = [ "@wheel" ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable =
        if (systemSettings.boot == "uefi") then true else false;
      efi.canTouchEfiVariables =
        if (systemSettings.boot == "uefi") then true else false;
      efi.efiSysMountPoint =
        systemSettings.bootPath; # does nothing if running bios rather than uefi
      grub.enable = if (systemSettings.boot == "uefi") then false else true;
      grub.device =
        systemSettings.grubDevice; # does nothing if running uefi rather than bios
    };
    kernelModules = [ "i2c-dev" "i2c-piix4" "cpufreq_powersave" ];
  };

  networking = {
    hostName = systemSettings.hostname; # Define your hostname.
    networkmanager.enable = true; # Enable networking
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = let l = "en_US.UTF-8";
  in {
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

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    # Enable X11 display server
    enable = true;
    # displayManager.sessionCommands = mySessionCommands;
  };

  services.libinput.touchpad.disableWhileTyping = true;

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups =
      [ "networkmanager" "wheel" "input" "dialout" "video" "audio" "render" ];
    packages = [ ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "chu";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Do not forget to add an editor to edit configuration.nix! The Nano editor
  # is also installed by default.
  environment.systemPackages = with pkgs; [
    vim
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
      # by librephoenix
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
            echo "Adding Home Manager channel to channel list..."
            nix-channel --add \
              https://github.com/nix-community/home-manager/archive/master.tar.gz \
      	      home-manager

            # Pull channel updates from channel list:
            echo "Pulling Home Manager channel updates in..."
            nix-channel --update

            # Generate a minimal Home Manager config at ~/.config/home-manager/home.nix
            echo "Generating Home Manager configuration..."

            nix run home-manager/master -- init --switch $DOTFILES_DIR

            echo "Home Manager configuration generated."

            # Flake inputs aren't updated by Home Manager, so we need to do it
            # ourselves:
            nix flake update

            echo "Installing Home Manager..."

            # Install Home Manager via nix-shell.
            nix-shell '<home-manager>' -A install

            # Build and activate flake-based Home Manager configuration
            home-manager switch --flake $DOTFILES_DIR

            echo "Actually done for real now!"
            echo ""
            echo "The home-manager tool should now be installed and you can edit"
            echo ""
            echo "    $DOTFILES_DIR/home.nix"
            echo ""
            echo "to configure Home Manager. Run 'man home-configuration.nix' to"
            echo "see all available options."
    '')
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

  # Enable the copy/paste support for virtual machines.
  services.spice-vdagentd.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  fonts.fontDir.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
