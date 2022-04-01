{ home-manager, config, lib, ... }:
{
  programs.autorandr = {
    enable = true;
    profiles = {
      laptop = { };
    };
  };
}
