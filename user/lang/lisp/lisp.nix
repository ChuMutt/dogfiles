{ pkgs, ... }: {
  home.packages = with pkgs; [
    rlwrap
    roswell
    mitscheme
    chicken
    guile
    racket
    fennel
    janet
  ];
}
