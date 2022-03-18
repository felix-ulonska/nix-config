{ pkgs, config, inputs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
    timeular
    logseq
    nerdfonts
  ];

  services.nextcloud-client = {
    enable = true;
  };
}
