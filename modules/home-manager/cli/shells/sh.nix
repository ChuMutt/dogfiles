{ pkgs, ... }:
let
  aliases = {
    g = "git";
    ga = "git add .";
    gc = "git commit -m";
    "..." = "cd ../..";
    "...." = "cd ../../..";
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
