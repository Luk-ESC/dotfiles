{ pkgs, lib, ... }:
{

  persist.data.contents = [
    ".local/share/zed/"
  ];

  persist.caches.contents = [
    ".local/share/zed/node/cache/"
  ];

  persist.logs.contents = [
    ".local/share/zed/node/cache/_logs/"
    ".local/share/zed/logs/"
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
    ];

    userSettings = {
      inlay_hints.enabled = true;

      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      terminal.shell.program = "zsh";
      terminal.env.TERM = "alacritty";

      lsp = {
        nil = {
          binary.path = lib.getExe pkgs.nil;
          initialization_options.formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
        };
        nixd = {
          binary.path = lib.getExe pkgs.nixd;
          initialization_options = {
            options = {
              home-manager = {
                expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []";
              };
            };
          };
        };
      };
    };
  };
}
