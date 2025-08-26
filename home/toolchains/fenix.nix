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

  toolchain = pkgs.fenix.complete;

  toml = pkgs.formats.toml { };
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
  programs.zed-editor.userSettings.lsp.rust-analyzer.binary.path =
    lib.getExe' toolchain.rust-analyzer "rust-analyzer";

  home.file.".cargo/config.toml".source = toml.generate "config.toml" cargo_config;
}
