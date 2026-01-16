{ pkgs, ... }:
{
  home.packages = [
    pkgs.teams-for-linux
  ];

  persist.session.contents = [ ".config/teams-for-linux/" ];
}
