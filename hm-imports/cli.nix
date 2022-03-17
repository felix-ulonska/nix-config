{ home-manager, config, lib, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    extraConfig = {
      user.name = "Felix Ulonska";
      user.email = "git@webfoo.de";
    };
  };
}
