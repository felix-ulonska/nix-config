{ pkgs, config, inputs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
    timeular
    logseq
    nerdfonts
    pavucontrol
    discord
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
    android-studio

    zathura
    bitwarden
    inkscape
    azuredatastudio
    ranger
    element-desktop
    gnome.gnome-boxes
    libxml2
    arandr
    touchegg
    neovide
    libreoffice
    signal-desktop
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
