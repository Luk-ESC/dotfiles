{
  pkgs,
  ...
}:
{
  programs.helix.extraPackages = [
    pkgs.qt6.qtdeclarative
  ];
}
