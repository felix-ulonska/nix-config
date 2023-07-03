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
    ( (import (fetchFromGitHub {
      owner = "NixOS";
      repo= "nixpkgs";
      rev ="077648b1a7a890c87d521cada0eb561571ef8d7b";
      sha256 = "sha256-PxCjEPoKzHX6boFpjNBoWWVZYpNbVIYAdU9kf67HlSY=";
    })) {system = "x86_64-linux"; }).vagrant
    virt-manager
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
