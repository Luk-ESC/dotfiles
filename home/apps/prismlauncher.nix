{ pkgs, ... }:
{
  home.packages = [ pkgs.prismlauncher ];

  persist = {
    data.contents = [
      ".local/share/PrismLauncher/"
    ];

    logs.contents = [
      ".local/share/PrismLauncher/logs/"
    ];

    caches.contents = [
      ".local/share/PrismLauncher/cache/"
    ];
  };
}
