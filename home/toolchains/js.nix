{ pkgs, ... }:
{
  programs.bun = {
    enable = true;
    enableGitIntegration = false; # Only needed for old file format
  };

  programs.helix = {
    extraPackages = [
      (pkgs.callPackage ../../pkgs/angular_language_server.nix { })
      pkgs.typescript-language-server
      pkgs.superhtml
    ];

    languages.language = [
      {
        name = "html";
        language-servers = [
          "angular"
          "superhtml"
        ];
      }
      {
        name = "typescript";
        language-servers = [
          "angular"
          "typescript-language-server"
        ];
      }
    ];
  };
}
