{ pkgs, ... }:
let
  aliases = {
    g = "git";
    ga = "git add .";
    gc = "git commit -m";

    "..." = "cd ../..";
    "...." = "cd ../../..";

    "chu-sync" = " sudo nixos-rebuild switch --flake ~/.config/dogfiles/#$HOST";

  };
in {
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      shellAliases = aliases;
      initExtra = ''
        PROMPT=" ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
         %F{green}→%f "
        RPROMPT="%F{red}▂%f%F{yellow}▄%f%F{green}▆%f%F{cyan}█%f%F{blue}▆%f%F{magenta}▄%f%F{white}▂%f"
        [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
      '';
    };
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = aliases;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
  home.packages = with pkgs; [

    sl
    cowsay
    ponysay
    lolcat
    terminal-parrot
    bat
    fd
    bc
    direnv
    nix-direnv
    tldr

  ];
}
