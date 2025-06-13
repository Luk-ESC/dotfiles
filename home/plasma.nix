{ pkgs, ... }: {
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace = {
      colorScheme = "BreezeDark";
      iconTheme = "Papirus-Dark";
      cursor = {
        size = 24;
        theme = "Bibata-Modern-Classic";
      };
    };

    input.keyboard.layouts = [{
      layout = "at";
      variant = "nodeadkeys";
    }];

    shortcuts = { };
    configFile = { };
    dataFile = { };
  };

  home.packages = with pkgs; [ papirus-icon-theme ];
}
