{ ... }: {
  home.persistence."/nix/persist/home/jabbi" = {
    directories = [
      "Downloads"
      "Documents"
      "Nextcloud"
      "Arbeit"
      "Projects"
      ".logseq"
      ".config/nextcloud"
      ".config/keepassxc"
      ".config/discord"
      ".config/nautilus"
      ".config/pulse"
      #".config"
      ".cache/Cypress"
      ".mozilla"
      #".local/share/gnome-settings-daemon"
      #".local/share/gnome-shell"
    ];
    files = [ ".zsh_history" ".ssh/known_hosts" ".config/gnome-initial-setu-done" ];
  };
}
