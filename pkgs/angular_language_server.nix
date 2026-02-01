{
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  name = "@angular/language-server";
  version = "19.2.3";

  src = fetchurl {
    url = "https://registry.npmjs.org/@angular/language-server/-/language-server-${version}.tgz";
    hash = "sha256-R1AUAs/y484CteF1bGqKoDVNMrMyXNIOgJxUJcnti6w=";
  };

  postPatch = ''
    cp ${./ng-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-tudSRLE5VXZOeGNHi1z22s2rLBhpm1CUDjaTf0DvNBs=";
  dontNpmBuild = true;

  meta = {
    mainProgram = "ngserver";
  };
}
