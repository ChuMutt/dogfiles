# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, systemSettings, userSettings, ... }:

let
  mySessionCommands = ''
    xset -dpms
    xset s blank
    xset r rate 350 50
    xset s 300
  '';
  in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # (./. + "../../../system/wm"+("/"+userSettings.wm)+".nix") # My window manager
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "chunixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

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
    displayManager.sessionCommands = mySessionCommands;
  };

  services.libinput.touchpad.disableWhileTyping = true;

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chu = {
    isNormalUser = true;
    description = "chu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [ ];
    useDefaultShell = true; # use pkgs.zsh
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "chu";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Do not forget to add an editor to edit configuration.nix! The Nano editor
  # is also installed by default.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    spice-vdagent # Provides copy/paste support if this is a VM guest.
    git
    tldr
    nixfmt-rfc-style
    nh
    xclip
    bottom
    htop-vim
    beets
    # Shell script template (no shebang required):
    # (writeShellScriptBin "name" ''
    #
    # '')
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
    xdg-user-dirs

    # audio
    audacity
    tenacity
    airwindows-lv2
    alsa-scarlett-gui
    ardour
    bitwig-studio
    calf
    drumgizmo
    geonkick
    goattracker
    guitarix
    helvum
    jamesdsp
    jconvolver
    milkytracker
    mixxx
    musescore
    odin2
    paulstretch
    pavucontrol
    raysession
    reaper
    renoise
    roomeqwizard
    scream
    touchosc
    vcv-rack
    vorbis-tools
    wolf-shaper

    # image / video
    ffmpeg
    mpd
    mpv
    cheese
    kdenlive
    krita
    gimp
    inkscape

    # communications
    discord
    telegram-desktop

  ];

  environment = {
    variables = { DOTFILES_DIR = "$HOME/.dogfiles"; };
    sessionVariables = { DOTFILES_DIR = "$HOME/.dogfiles"; };
    pathsToLink = [ "/share/zsh" ]; # For zsh.enableCompletion in home.nix
  };

  environment.plasma6.excludePackages = with pkgs; [
    kate
    okular
    plasma-systemmonitor
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh = { enable = true; };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow members of the wheel group to connect to the Nix daemon.
  # Default is * (all). Root is always allowed regardless of this setting.
  # This is required for standalone home-manager (which this setup uses).

  nix.settings.allowed-users = [ "@wheel" ];

  # Allow members of the wheel group to connect to the Nix daemon, specify
  # additional binary caches, and import unsigned NARs. Default is root.

  nix.settings.trusted-users = [ "root" "@wheel" ];


  # Enable KDE Plasma 6 Desktop
  # services = {
  #   displayManager.sddm.enable = true;
  #   desktopManager.plasma6.enable = true;
  # };

  # Enable KDE Plasma 5 Desktop
  # services = {
  #   displayManager.sddm.enable = true;
  #   displayManager.sessionCommands = mySessionCommands;
  #   desktopManager.plasma5.enable = true;
  # };

  # Enable GNOME Desktop
  # services = {
  #   displayManager.gdm.enable = true;
  #   displayManager.sessionCommands = mySessionCommands;
  #   desktopManager.gnome.enable = true;
  # };
  
  # Automatically select display configuration based on connected devices
  services.autorandr.enable = true;
  
}
