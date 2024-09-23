{ pkgs, userSettings, ... }:
{
  # Module installing librewolf as default browser
  home.packages =
    if (userSettings.wmType == "wayland") then [ pkgs.firefox-wayland ] else [ pkgs.firefox ];
  home.sessionVariables =
    if (userSettings.wmType == "wayland") then
      {
        DEFAULT_BROWSER = "${pkgs.firefox-wayland}/bin/firefox";
      }
    else
      {
        DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
      };
  programs.firefox.enable = true;
  programs.firefox.profiles.chu.settings.extensions.autoDisableScopes = 0;
  programs.firefox.profiles.chu.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    privacy-badger
  ];
}
