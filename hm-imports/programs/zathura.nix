{ pkgs, config, inputs, scheme, ... }:
{
  programs.zathura.enable = true;
  programs.zathura.extraConfig =
    builtins.readFile (scheme inputs.base16-zathura);
}
