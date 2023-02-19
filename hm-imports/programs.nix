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
    libreoffice

    nixpkgs-fmt
    usbmuxd
    zoom-us

    networkmanagerapplet
    #flutter
    obs-studio
    android-studio

    zathura
    bitwarden
    inkscape
    azuredatastudio
    ranger
    element-desktop
    (import inputs.nixpkgsUnity { system = "x86_64-linux"; config.allowUnfree = true; }).unityhub
    # ((import inputs.nixpkgsFlake {system = "x86_64-linux"; config.allowUnfree = true;}).hochwasser)
    gnome.gnome-boxes
    libxml2
    arandr
    touchegg
    neovide
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
