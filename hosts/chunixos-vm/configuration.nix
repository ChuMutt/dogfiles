# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

{
  imports = [

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Include system modules
    ../../modules/nixos/default.nix

    # Include user module
    ../../modules/profiles/default.nix

    # Include user home configuration
    inputs.home-manager.nixosModules.default

  ];

  # Enable user module
  chu = {
    enable = true;
    userName = "chu";
  };

  # Bootloader.
  boot = {
    loader = {
      # systemd-boot (UEFI)
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-c233bfdc-56f5-4381-982a-3e17a746e0da".device =
      "/dev/disk/by-uuid/c233bfdc-56f5-4381-982a-3e17a746e0da";
  };

  networking = {
    hostName = "chunixos-vm"; # Define your hostname.
    networkmanager.enable = true; # Enable networking
    # Enables wireless support via wpa_supplicant.
    # wireless.enable = true; # Incompatible with NetworkManager.
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;

    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    # Enable the GNOME Desktop Environment.
    # displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;

    # Enable the suckless dynamic window manager.
    # windowManager.dwm.enable = true;

    # Enable Emacs X Window Manager (EXWM)
    # windowManager.exwm.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chu = {
    isNormalUser = true;
    description = "chu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird

      tldr
      neovim
      wget
      git

      # custom scripts
      # TODO fix this script because it doesn't work
      (writeShellScriptBin "chu-install-home-manager-unstable" ''
              # doesn't work currently
                # home-manager is recommended for this setup
                # this installs the standalone version (recommended)
                nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager &&
                nix-channel --update &&
                nix-shell '<home-manager>' -A install
        	# then run home-manager switch --flake ~/.config/dogfiles/#chunix
      '')
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      home-manager
      protonup # imperative bootstrap for proton-ge
      nixfmt-rfc-style
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        "\${XDG_DATA_DIR}/steam/root/compatibilitytools.d";
    };

    shells = with pkgs; [ zsh ];

  };

  startx.enable =
    true; # otherwise defaults to lightdm gtk greeter when you log in

  security = {
    sudo = { enable = true; };
    rtkit.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    zsh.enable = true;
    nh.enable = true;
    firefox.enable = true;
    steam.enable = true;
    gamemode.enable = true;

  };

  # List services that you want to enable:
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    xserver.libinput.enable = true;
  };

  hardware = {
    # Enable bluetooth.
    bluetooth.enable = true;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  home-manager = {
    # Pass inputs to home-manager modules.
    extraSpecialArgs = { inherit inputs; };
    users = { "chu" = import ../../home.nix; };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Allow unfree packages. Sorry, rms.
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";

}
