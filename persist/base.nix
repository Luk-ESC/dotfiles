{lib, ...}:
rec {
  persistentOption = with lib; with lib.types; mkOption {
    description = "submodule example";
    type = attrsOf (submodule {
      options = {
        prefix = mkOption {
          default = "/persistent/";
          type = strMatching "^/([[:alnum:]_]+/)?$";
        };
        contents = mkOption {
          default = [ ];
          type = nonEmptyListOf nonEmptyStr;
        };
      };
    });
  };


  isDirectory = lib.hasSuffix "/";
  isSystem = lib.hasPrefix "/";
  not = f: a: !(f a);
  stripTrailing = p: lib.substring 0 (builtins.stringLength p - 1) p;
  filter2 = f: g: c: builtins.filter f (builtins.filter g c);

  parseUserDirectories = paths: map stripTrailing (filter2 (not isSystem) isDirectory paths);
  parseUserFiles = paths: filter2 (not isSystem) (not isDirectory) paths;

  parseSystemDirectories = paths: map stripTrailing (filter2 isSystem isDirectory paths);
  parseSystemFiles = paths: filter2 isSystem (not isDirectory) paths;
  dirsAndFiles = isSystem: contents: {
    directories = (if isSystem then parseSystemDirectories else parseUserDirectories) contents;
    files = (if isSystem then parseSystemFiles else parseUserFiles) contents;
  };
}
