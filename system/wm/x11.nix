{ pkgs, ... }:
# TODO be able to pick between kde/gnome/suckless & be able to extend
{
  imports = [ ./pipewire.nix ./dbus.nix ./gnome-keyring.nix ];

  services = {
    xserver = {
      enable = true; # Enable the X11 windowing system.
      xkb = { # Configure keymap in X11
        layout = "us";
        variant = "";
        options = "caps:escape";
      };

      displayManager = {
        sddm.enable = true; # KDE
        # gdm.enable = true; # GNOME
        # lightdm.enable = true; # Canonical
        # startx.enable = true; # none
        sessionCommands = ''
          xset b off
          xset -dpms
          xset r rate 350 50
        '';
      };

      desktopManager = {
        # Enable the KDE Plasma Desktop Environment.
        plasma6.enable = true; # KDE
        # gnome.enable = true; # GNOME
      };
    };

    # windowManager = {
    # dwm.enable = true; # suckless
    # exwm.enable = true; # emacs
    # };

    # For virtual machine guests to enable a daemon allowing for clipboard (copy/paste) sharing.
    spice-vdagentd.enable = true;

    libinput = {
      enable =
        true; # Enable touchpad support (enabled default in most desktopManager).
      touchpad.disableWhileTyping = true;
    };

  };
}
