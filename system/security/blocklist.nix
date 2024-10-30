{ inputs, ... }:
let
  blocklist = builtins.readFile
    "${inputs.blocklist-hosts}/hosts";
in {
  networking.extraHosts = ''
    "${blocklist}"
  '';
}
