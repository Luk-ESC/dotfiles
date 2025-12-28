{ pkgs, ... }:
{
  home.packages = [ pkgs.mattermost-desktop ];

  persist.session.contents = [
    ".config/Mattermost/"
  ];
}
