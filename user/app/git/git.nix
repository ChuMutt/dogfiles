{ pkgs, userSettings, ... }: {
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
  programs.git.userName = userSettings.name;
  programs.git.userEmail = userSettings.email;
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    safe.directory =
      [ userSettings.dotfilesDir (userSettings.dotfilesDir + "/.git") ];
  };
}
