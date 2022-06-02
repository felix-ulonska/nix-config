{ ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      "NIXPKGS_ALLOW_UNFREE" = 1;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "robbyrussell";
    };
  };
}
