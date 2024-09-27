{ pkgs, ... }:
let
  myAliases = {
    g = "git";
    ga = "git add .";
    gc = "git commit -m";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "doom" = "~/.config/emacs/bin/doom ";
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
      enable = true;
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
    starfetch
    gnugrep
    gnused
    bat
    bottom
    fd
    bc
    direnv
    nix-direnv

    asciiquarium-transparent
    cmatrix
    ponysay
    terminal-parrot
    tldr
    ripgrep
    rsync
    cava
    killall
    libnotify
    timer
    eza
    unzip
    w3m
    hwinfo
    pciutils
    brightnessctl
    pandoc
  ];
}
