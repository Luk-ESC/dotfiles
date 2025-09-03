{ pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../pkgs/packetTracer.nix { })
  ];

  persist.logs.contents = [
    "pt/logs/"
  ];

  persist.data.contents = [
    "pt/saves/"
  ];

  persist.session.contents = [
    "pt/"
  ];
}
