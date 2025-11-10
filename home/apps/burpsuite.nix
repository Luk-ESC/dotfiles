{ pkgs, ... }:
{
  home.packages = [
    pkgs.burpsuite
  ];

  persist.session.contents = [
    ".BurpSuite/"
    ".java/.userPrefs/burp/"
  ];
}
