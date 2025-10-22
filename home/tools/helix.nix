{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = [
      pkgs.nil
      pkgs.nixd
      pkgs.nixfmt-rfc-style
    ];

    settings = {
      editor = {
        mouse = false;
        middle-click-paste = false;

        preview-completion-insert = false;
        color-modes = true;

        lsp.display-inlay-hints = true;
        lsp.inlay-hints-length-limit = 80;
      };

      keys.normal = {
        left = "no_op";
        right = "no_op";
        down = "no_op";
        up = "no_op";
      };
    };

    languages.language = [
      {
        name = "nix";
        formatter.command = "nixfmt";
        auto-format = true;
      }
    ];
  };
}
