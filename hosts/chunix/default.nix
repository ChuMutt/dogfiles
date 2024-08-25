{ lib, ... };

with lib;
with bultins;
{
  system = "x86_64-linux";

  modules = {
    xdg.ssh.enable = true;

    profiles = {
      role = "workstation";
      user = "chu";
      networks=["us"];
      hardware = [
        "cpu/amd"
        "gpu/amd"
        "audio"
        "audio/realtime"
        "ssd"
      ];
    };
    desktop = {
      dwm.enable = true;
      term.default = "st";
      term.st.enable = true;
      browsers.default = "librewolf";
    };
  };
}
