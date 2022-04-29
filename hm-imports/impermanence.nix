{ ... }: {
  # FUSE Mounts are painfully slow!
  home.persistence."/nix/persist/home/jabbi" = {
    directories = [
      "Downloads"
      "Documents"
      "Nextcloud"
      "Arbeit"
      "opt"
      "Projects"
      ".logseq"
      ".config/Nextcloud"
      ".config/keepassxc"
      ".config/discord"
      ".config/Timeular"
      ".config/nautilus"
      ".config/pulse"
      ".config/Microsoft Teams - Preview"
      ".config/Microsoft"
      ".config/team"
      ".config/spotify"
      ".config/goa-1.0"
      ".config/Logseq"
      ".config/geary"
      ".config/syncthing"
      #".config"
      ".cache/Cypress"
      ".local/share/containers"
      ".local/share/keyrings"
      ".local/share/Steam"
      ".local/share/geary"
      ".mozilla"
      ".wine"
      ".ssh"
      "Android"
      #".local/share/gnome-settings-daemon"
      #".local/share/gnome-shell"
    ];
    files = [ ".zsh_history" ".config/gnome-initial-setu-done" ".npmrc" ];
    allowOther = true;
  };
}
