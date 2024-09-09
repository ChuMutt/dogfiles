{ pkgs, ... }: {
  imports = [ ../../modules/home-manager/default.nix ];
  home = {
    username = "chu";
    homeDirectory = "/home/chu";
    stateVersion = "24.05";
    packages = with pkgs; [
      zsh
      bash
      neovim
      git
      git-crypt
      tldr
      w3m
      xclip
      pulsemixer
      ispell
      aspell
      hunspell
      lf
      pciutils
      mediainfo
      nixfmt-classic
      pinentry
      direnv
      dwm
      st
      unclutter
      maim
      redshift
      slock
      firefox
      nextcloud-client
      keepassxc
      arandr
    ];
    # file = { ".xinitrc".text = "dwm"; };
    # sessionVariables = { EDITOR = "nvim"; };
  };
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = "chufilthymutt@gmail.com";
      userName = "chumutt";
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
      extraConfig = { push = { autoSetupRemote = true; }; };
    };
    zsh.enable = true;
    ssh.enable = true;
    gpg.enable = true;
    firefox.profiles.chu = {
      name = "chu";
      path = "chu";
      search = { default = "DuckDuckGo"; };
    };
  };
}
