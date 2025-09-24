{ pkgs, ... }:
{
  persist.caches.contents = [
    ".m2/repository/"
  ];

  programs.helix = {
    extraPackages = [
      pkgs.jdt-language-server
    ];
  };
}
