{ userSettings, ... }:

{
  security.sudo.enable = true;
  # security.sudo.extraRules = [
  #   {
  #     users = [ "${userSettings.username}" ];
  #     keepEnv = true;
  #     persist = true;
  #   }
  #   {
  #     users = [ "${userSettings.username}" ];
  #     cmd = "tee";
  #     noPass = true;
  #   }
  # ];

}
