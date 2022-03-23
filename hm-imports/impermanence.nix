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
      ".mozilla"
    ];
    files = [ ".zsh_history" ".ssh/known_hosts" ];
  };
}
