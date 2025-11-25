{pkgs, ...}: {
programs.helix = {
  enable = true;
  settings = {
    editor.cursor-shape = {
      normal = "block";
      insert = "bar";
      select = "underline";
    };
    keys.insert = {
      j = {
        k = "normal_mode";
      };      
    };
  };
  languages.language = [{
    name = "nix";
    auto-format = true;
    formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
  }];
  extraPackages = with pkgs; [
    omnisharp-roslyn
    netcoredbg
    nil
    protols
    rust-analyzer
    typescript-language-server
    ty
  ];
};
}
