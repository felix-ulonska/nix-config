{ pkgs, config, inputs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
    #inputs.nixpkgsMaster.legacyPackages."x86_64-linux".logseq
    #logseq
    #obsidian
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
    flameshot
    chromium
    scrcpy
    xournalpp

    nixpkgs-fmt
    zoom-us
    swaybg

    networkmanagerapplet

    zathura
    bitwarden
    inkscape
    ranger
    libxml2
    arandr
    touchegg
    neovide
    libreoffice
    signal-desktop
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
