{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linux;
    consoleLogLevel = 0;
  };
}
