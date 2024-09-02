{ ... }: {
  imports = [
    ./git/git.nix
    ./st/st.nix
    ./lf/lf.nix
    ./shells/sh.nix
    ./nvim/nvim.nix
  ];
}
