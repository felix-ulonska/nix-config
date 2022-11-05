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
    vlc
    lazydocker
    youtube-dl
    patchelf
    sshfs
    languagetool
    glab
    flameshot
    chromium
    scrcpy

    nixpkgs-fmt
    usbmuxd
    zoom-us

    networkmanagerapplet
    #flutter
    obs-studio
    android-studio

    gimp
    libreoffice

    zathura
    bitwarden
    inkscape
  ];

  programs.firefox = {
    enable = true;
    #extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #  ublock-origin
    #  vimium
    #];
  };

  services.nextcloud-client = {
    enable = true;
  };

  services.syncthing.enable = true;
}
