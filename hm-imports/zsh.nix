{ ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      "NIXPKGS_ALLOW_UNFREE" = 1;
    };
    initExtra =  "setopt appendhistory\nunsetopt HIST_SAVE_BY_COPY";
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
