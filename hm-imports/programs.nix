{ pkgs, config, inputs, ... }:
{
  programs.k9s.enable = true;
  home.packages = with pkgs; [
    keepassxc
    lazygit
    obsidian
    vscode
    (nerd-fonts.agave)
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
    bitwarden-desktop
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
