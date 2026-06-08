{
  pkgs,
  lib,
  config,
  ...
}:
let
  toolchain = pkgs.fenix.complete;
in
{
  home.packages = [
    (toolchain.withComponents [
      "cargo"
      "rust-src"
      "rustc"

      "rust-analyzer"
      "clippy"
      "rustfmt"
      "miri"
    ])
  ];

  programs.helix.extraPackages = [ toolchain.rust-analyzer ];

  programs.cargo = {
    enable = true;
    package = null;

    settings.build = {
      build-dir = "${config.xdg.cacheHome}/cargo_build_dir/{workspace-root}/";
      rustc-wrapper = lib.getExe pkgs.sccache;
      rustflags = [
        "-C"
        "link-arg=-fuse-ld=${lib.getExe pkgs.mold}"
        "-C"
        "linker=${lib.getExe pkgs.clang}"
      ];
    };
  };
}
