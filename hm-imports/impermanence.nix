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
      #".config/discord"
      ".mozilla"
      #".local/share/gnome-settings-daemon"
      #".local/share/gnome-shell"
    ];
    #files = [ ".zsh_history" ".ssh/known_hosts" ];
  };
}
