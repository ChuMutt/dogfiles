{ pkgs, ... }:
let
  # My shell aliases
  myAliases = {
    ls = "eza --icons -l -T -L=1";
    l = "ls -Al";
    cat = "bat";
    hop = "htop";
    fd = "fd -Lu";
    w3m = "w3m -no-cookie -v";
    neofetch = "disfetch";
    fetch = "disfetch";
    gitfetch = "onefetch";
    "," = "comma";
    ".." = "cd ./..";
    "..." = "cd ./../../";
    parrot = "terminal-parrot";
    g = "git";
    ga = "git add .";
    gc = "git commit -m";
    "doom" = "~/.config/emacs/bin/doom ";
  };
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autocd = true;
    shellAliases = myAliases;
    history = {
      size = 10000000; # Number of history lines to keep
      save = 10000000; # Number of history lines to save
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;
    initExtra = ''
      [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '

      # Enable colors and change prompt:
      autoload -U colors && colors # Load colors

      PS1="%B%{$fg[green]%}[%{$fg[magenta]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[green]%}]%{$reset_color%}$%b "

      # Basic auto/tab complete:
      autoload -U compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      compinit
      _comp_options+=(globdots)		# Include hidden files.

      # vi mode
      bindkey -v
      export KEYTIMEOUT=1

      # Use vim keys in tab complete menu:
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char

      # Use lf to switch directories and bind it to ctrl-o
      lfcd () {
      tmp=\"$(mktemp -uq)\"
      trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
      lf -last-dir-path=\"$tmp\" \"$@\"
      if [ -f \"$tmp\" ]; then
      dir=\"$(cat \"$tmp\")\"
      [ -d \"$dir\" ] && [ \"$dir\" != \"$(pwd)\" ] && cd \"$dir\"
      fi
      }
      bindkey -s '^o' '^ulfcd\n'
      bindkey -s '^a' '^ubc -lq\n'
      bindkey -s '^f' '^ucd \"$(dirname \"$(fzf)\")\"\n'
      bindkey '^[[P' delete-char

      # Edit line in vim with ctrl-e:
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line
      bindkey -M vicmd '^[[P' vi-delete-char
      bindkey -M vicmd '^e' edit-command-line
      bindkey -M visual '^[[P' vi-delete

      bindkey '^P' history-beginning-search-backward
      bindkey '^N' history-beginning-search-forward
    '';
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    disfetch
    lolcat
    cowsay
    onefetch
    gnugrep
    gnused
    bat
    eza
    bottom
    fd
    jq
    bc
    direnv
    nix-direnv
    nixfmt-rfc-style
    ripgrep
    rsync
    cava
    killall
    fortune
    hyfetch
    lolcat
    cowsay
    asciiquarium-transparent
    ponysay
    tealdeer
    tree
    pandoc
    eza
    timer
    starfetch
    unzip
    hwinfo
    pciutils
  ];

  # Per-directory shell environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
