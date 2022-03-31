{ pkgs, config, inputs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
    timeular
    logseq
    nerdfonts
    pavucontrol
    discord
    teams
    thunderbird
    spotify
    lazydocker
  ];

  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      vimium
    ];
  };

  services.nextcloud-client = {
    enable = true;
  };
}
