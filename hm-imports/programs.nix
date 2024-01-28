{ pkgs, config, inputs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
    #inputs.nixpkgsMaster.legacyPackages."x86_64-linux".logseq
    #logseq
    vscode
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
    xournalpp

    nixpkgs-fmt
    usbmuxd
    zoom-us
    swaybg

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
    virt-manager
    inputs.felixnixvim.packages.x86_64-linux.default
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
