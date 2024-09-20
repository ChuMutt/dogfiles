{ pkgs, ... }:
let
  myAliases = {
    g = "git";
    ga = "git add .";
    gc = "git commit -m";
    "..." = "cd ../..";
    "...." = "cd ../../..";
  };
in
{
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      shellAliases = myAliases;
      initExtra = ''
        PROMPT=" ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
        %F{green}→%f "
        # Disable some features to support TRAMP.
        if [ "$TERM" = dumb ]; then
          unsetopt zle prompt_cr prompt_subst
          unset RPS1 RPROMPT
          PS1='$ '
          PROMPT='$ '
        fi
      '';
    };
    bash = {
      # enable = true;
      enableCompletion = true;
      shellAliases = myAliases;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
  home.packages = with pkgs; [
    hyfetch
    lolcat
    cowsay
    sl
    starfetch
    cava
    asciiquarium-transparent
    cmatrix
    ponysay
    terminal-parrot
    vim
    neovim
    killall
    libnotify
    timer
    brightnessctl
    gnugrep
    bat
    fd
    eza
    bottom
    ripgrep
    rsync
    unzip
    bc
    direnv
    nix-direnv
    tldr
    w3m
    pandoc
    hwinfo
    pciutils
    (pkgs.writeShellScriptBin "airplane-mode" ''
      #!/bin/sh
      connectivity="$(nmcli n connectivity)"
      if [ "$connectivity" == "full" ]
      then
          nmcli n off
      else
          nmcli n on
      fi
    '')
  ];
}
