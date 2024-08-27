{ config, lib, pkgs, ... }: {
  options = { st.enable = lib.mkEnableOption "enables st"; };
  config = lib.mkIf config.st.enable { st.enable = true; };
}
