{ scheme, pkgs, ... }: {
  home.packages = with pkgs; [ ripgrep lazygit ];
  jabbi.nixvim.enable = true;
  jabbi.nixvim.base64scheme = {
    base00 = scheme.withHashtag.base00;
    base01 = scheme.withHashtag.base01;
    base02 = scheme.withHashtag.base02;
    base03 = scheme.withHashtag.base03;
    base04 = scheme.withHashtag.base04;
    base05 = scheme.withHashtag.base05;
    base06 = scheme.withHashtag.base06;
    base07 = scheme.withHashtag.base07;
    base08 = scheme.withHashtag.base08;
    base09 = scheme.withHashtag.base09;
    base0A = scheme.withHashtag.base0A;
    base0B = scheme.withHashtag.base0B;
    base0C = scheme.withHashtag.base0C;
    base0D = scheme.withHashtag.base0D;
    base0E = scheme.withHashtag.base0E;
    base0F = scheme.withHashtag.base0F;
  };
}
