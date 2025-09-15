{
  lib,
  buildPythonPackage,
  fetchPypi,
  scikit-build-core,
  cmake,
  ninja,
  nanobind,
  elfutils,
  libiberty,
  pkg-config,
  typing-extensions,
  psutil,
  pyelftools,
  prompt-toolkit,
  requests,
}:

buildPythonPackage rec {
  pname = "libdebug";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rk2Cq7YpN/z530LAFzWKm1I33j24rsSKbQV7Ezv5E34=";
  };

  # disable libdwarf usage
  CMAKE_ARGS = "-DUSE_LIBDWARF=OFF -DUSE_LIBELF=ON -DUSE_LIBIBERTY=ON"; # no libdwarf!
  # scikit-build-core runs cmake internally
  dontUseCmakeConfigure = true;

  buildInputs = [
    elfutils
    libiberty
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  build-system = [
    nanobind
    scikit-build-core
    typing-extensions
  ];

  propagatedBuildInputs = [
    psutil
    pyelftools
    prompt-toolkit
    requests
  ];

  # homeless-shelter
  preBuild = ''
    export HOME="$TMPDIR"
  '';

  preCheck = preBuild;
  doCheck = true;
  pythonImportsCheck = [ "libdebug" ];

  meta = with lib; {
    description = "A Python library to debug binary executables, your own way.";
    homepage = "https://libdebug.org/";
    changelog = "https://github.com/libdebug/libdebug/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      Frank01001
      MrIndeciso
      Io-no
      JinBlack
    ];
  };
}
