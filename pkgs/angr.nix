# FIXME(NixOS/nixpkgs#501379): remove once NixOS/nixpkgs#487341 lands in 26.05
{
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  cargo,
  rustc,
  cmake,
  ninja,
  ...
}:
python-self: python-super:
let
  version = "9.2.197";
  fetch =
    repo: hash:
    fetchFromGitHub {
      owner = "angr";
      inherit repo hash;
      tag = "v${version}";
    };
in
with python-self;
{
  archinfo = python-super.archinfo.overridePythonAttrs {
    inherit version;
    src = fetch "archinfo" "sha256-j5vyRyP9Q7kdjlvncrjXDXX38zNUsjZn8MgQGfBtISc=";
  };

  claripy = python-super.claripy.overridePythonAttrs {
    inherit version;
    src = fetch "claripy" "sha256-/l7Na3vNRB8G6F0dQSkrEFlMUaZG0XW3mZ+2Kjkwzos=";
  };

  pyvex = python-super.pyvex.overridePythonAttrs (old: {
    inherit version;
    src = (fetch "pyvex" "sha256-FRt+tCQLK2GFIwgCvUoRmxPGBryceJ+62tSK9WLMKQk=").override {
      fetchSubmodules = true;
    };
    build-system = old.build-system ++ [ scikit-build-core ];
    nativeBuildInputs = old.nativeBuildInputs ++ [
      cmake
      ninja
    ];
    dontUseCmakeConfigure = true;
    preBuild = "export CC=${stdenv.cc.targetPrefix}cc";
  });

  cle = python-super.cle.overridePythonAttrs (old: {
    inherit version;
    src = fetch "cle" "sha256-8hA4r1y5tItyWPGJCMQnmLx1fRfEGjmGH86x+9WqSRQ=";
    pythonRelaxDeps = [ "arpy" ];
    # pyxdia (PDB support) isn't packaged in nixpkgs yet
    pythonRemoveDeps = [ "pyxdia" ];
    postPatch = ''
      substituteInPlace cle/backends/pe/pe.py --replace-fail "import pyxdia" \
        "$(printf 'try:\n    import pyxdia\nexcept ImportError:\n    pyxdia = None')"
    '';
    dependencies = old.dependencies ++ [
      arpy
      minidump
      pyxbe
      uefi-firmware-parser
    ];
    doCheck = false;
  });

  angr = python-super.angr.overridePythonAttrs (old: rec {
    inherit version;
    src = fetch "angr" "sha256-EMTYn6pvZaVb4mimRYfOt21wOUBTQD7YLhAzU9PpP5w=";
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (old) pname;
      inherit version src;
      hash = "sha256-/IQCbZUVGV5WNzIIELr5tfFPOITUqHj+zp8FH2bAuCU=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      rustPlatform.cargoSetupHook
      cargo
      rustc
      setuptools-rust
    ];
    dependencies = builtins.filter (p: p.pname or "" != "ailment") old.dependencies ++ [
      lmdb
      msgspec
      pypcode
    ];
  });
}
