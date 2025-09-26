{ pkgs, ... }:
{
  home.packages = [ pkgs.mysql-workbench ];

  persist.logs.contents = [
    ".mysql/workbench/log/"
  ];

  persist.session.contents = [
    ".mysql/workbench/"
  ];
}
