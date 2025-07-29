{ lib, ... }:

with builtins;
with lib;
rec {
  addIfExists = path: list: [ path ] ++ list;# path: list: if builtins.pathExists path then list ++ [ path ] else list;
}
