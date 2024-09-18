{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    virt-manager
    looking-glass-client
    # distrobox
  ];
  virtualisation.libvirtd = {
    allowedBridges = [ "nm-bridge" "virbr0" ];
    enable = true;
    qemu.runAsRoot = false;
  };
  # virtualisation.waydroid.enable = true;
}
