{ pkgs, config, inputs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
    #inputs.nixpkgsMaster.legacyPackages."x86_64-linux".logseq
    #logseq
    lazygit
    obsidian
    vscode
    (nerdfonts.override { fonts = [ "Agave" ]; })
    pavucontrol
    discord
    thunderbird
    spotify
    vlc
    lazydocker
    patchelf
    sshfs
    languagetool
    flameshot
    chromium
    scrcpy
    xournalpp
    gh

    wget

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
    kubectl
    graphite-cli
    zellij 
    #inputs.felixnixvim.packages.x86_64-linux.default
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
