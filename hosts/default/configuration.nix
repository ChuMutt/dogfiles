# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./chu.nix
    inputs.home-manager.nixosModules.default
    ../../modules/default.nix
  ];

  chu.enable = true;
  chu.userName = "chu";

  # Bootloader.
  boot = {
    loader = {
      # systemd-boot (UEFI)
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-c233bfdc-56f5-4381-982a-3e17a746e0da".device = "/dev/disk/by-uuid/c233bfdc-56f5-4381-982a-3e17a746e0da";
  };

  networking = {
    hostName = "chunixos"; # Define your hostname.
    networkmanager.enable = true; # Enable networking
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
  services.xserver = {
    enable = true;
    windowManager.dwm.enable = true;
    # Configure keymap in X11
    xkb.layout = "us";
    # videoDrivers = [ "amdgpu" ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {

    systemPackages = with pkgs; [
      # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      home-manager
      protonup # imperative bootstrap for proton-ge
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${XDG_DATA_DIR}/steam/root/compatibilitytools.d";
    };
  };

  # system modules
  ## shells
  zsh.enable = true;
  ## version control (vc)
  git.enable = true;
  ## editor(s)
  neovim.enable = true;
  ## display manager(s) (login screens)
  startx.enable = true; # otherwise defaults to lightdm gtk greeter when you log in
  ## terminal emulators
  st.enable = true;
  ## file manager(s)
  lf.enable = true;
  ## browser(s)
  firefox.enable = true;

  security = {
    sudo = {
      enable = true;
      # Wheel can sudo w/o password
      extraConfig = ''
        %wheel ALL=(ALL:ALL) ALL
        %wheel ALL=(ALL:ALL) NOPASSWD: /bin/shutdown,/bin/reboot,/bin/systemctl suspend,/bin/wifi-menu,/bin/mount,/bin/umount
      '';
    };
    rtkit.enable = true;
  };
  programs = {

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    steam.enable = true;
    gamemode.enable = true;

  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  #opengl
  hardware.graphics = {
    enable = true;
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "chu" = import ./home.nix;
    };
  };

  system.stateVersion = "24.11"; # Do not change.

  nix.settings.experimental-features = "nix-command flakes";

}
