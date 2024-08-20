{ config, lib, pkgs, ... }:

let
  myShellAliases = {
    supdate = "sudo nixos-rebuild switch --flake ~/.dotfiles";
    hupdate = "home-manager switch --flake ~/.dotfiles";
    update = "supdate && hupdate";

    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -vI";
    bc = "bc -ql";
    rsync = "rsync -vrPlu";
    mkd = "mkdir -pv";
    yt = "yt-dlp --embed-metadata -i";
    yta = "yt -x -f bestaudio/best";
    ytt = "yt --skip-download --write-thumbnail";
    ffmpeg = "ffmpeg -hide_banner";
    lsblk = "lsblk --output NAME,LABEL,TRAN,TYPE,SIZE,FSUSED,FSTYPE,MOUNTPOINT";

    # Colorize commands when possible.
    ls = "ls -hN --color=auto --group-directories-first";
    grep = "grep --color=auto";
    diff = "diff --color=auto";
    ccat = "highlight --out-format=ansi";
    ip = "ip -color=auto";
  };
in {
  # Zsh; which is also enabled system-wide in /etc/nixos/configuration.nix,
  # as otherwise it wouldn't be able to source necessary files.
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = myShellAliases;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

  };

  programs.bash = {
    enable = true;
    shellAliases = myShellAliases;
  };

}
