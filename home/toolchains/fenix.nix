{
  pkgs,
  lib,
  config,
  ...
}:
let
  cargo_config = {
    build = {
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

  toml = pkgs.formats.toml { };
in
{
  home.packages = [
    (pkgs.fenix.complete.withComponents [
      "cargo"
      "rust-src"
      "rustc"

      "rust-analyzer"
      "clippy"
      "rustfmt"
      "miri"
    ])
  ];

  home.file.".cargo/config.toml".source = toml.generate "config.toml" cargo_config;
}
