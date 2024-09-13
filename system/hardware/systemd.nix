{ ... }:

{ # systemd journal garbage collection/refusal
  services.journald = {
    extraConfig = ''
      SystemMaxUse=50M
      SystemMaxFiles=5'';
    rateLimitBurst = 500;
    rateLimitInterval = "30s";
  };
}
