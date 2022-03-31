{ ... }: {
  home.persistence."/nix/persist/home/jabbi" = {
    directories = [
      "Downloads"
      "Documents"
      "Nextcloud"
      "Arbeit"
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
      ".config/Logseq"
      #".config"
      ".cache/Cypress"
      ".local/share/containers"
      ".mozilla"
      ".ssh"
      #".local/share/gnome-settings-daemon"
      #".local/share/gnome-shell"
    ];
    files = [ ".zsh_history" ".config/gnome-initial-setu-done" ".npmrc" ];
  };
}
