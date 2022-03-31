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
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "screen-256color-bce";
    tmuxinator.enable = true;
  };
}
