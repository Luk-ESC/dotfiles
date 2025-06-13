{ config, pkgs, ... }: {
  home.packages = with pkgs; [ nil nixd alejandra ];

  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" ];

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
        nil = { initialization_options.formatting.command = [ "alejandra" ]; };
        nixd = {
          initialization_options = {
            options = {
              home-manager = {
                expr =
                  "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []";
              };
            };
          };
        };
      };
    };
  };
}
