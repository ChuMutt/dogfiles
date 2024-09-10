{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rlwrap
    roswell
    # mitscheme
    # chez
    # chicken
    # guile
    # racket
    # fennel
    # janet
  ];
}
