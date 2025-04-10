{ pkgs, config, inputs, ... }:
{
  programs.k9s.enable = true;
  home.packages = with pkgs; [
    keepassxc
    lazygit
    obsidian
    vscode
    (nerdfonts.override { fonts = [ "Agave" ]; })
    pavucontrol
    discord
    thunderbird
    spotify
    vlc
    patchelf
    sshfs
    languagetool
    flameshot
    chromium
    xournalpp

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
    libreoffice
    signal-desktop
    kubectl
    graphite-cli
    zellij
    glances
    mqttx

    inputs.zen-browser.packages."x86_64-linux".default
  ];
  programs.btop.enable = true;

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
