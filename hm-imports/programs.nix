{ pkgs, config, inputs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
    timeular
    logseq
  ];

  services.nextcloud-client = {
    enable = true;
  };
}
