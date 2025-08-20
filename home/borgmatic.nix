let
  # Initialised with: nix run nixpkgs#borgbackup -- init /persistent/data/home/eschb/borgrepo -e none
  localrepo = "/persistent/data/home/eschb/borgrepo";
in
{
  services.borgmatic.enable = true;
  programs.borgmatic = {
    enable = true;
    backups = {
      data = {
        retention = {
          keepHourly = 8;
          keepDaily = 7;
          keepWeekly = 3;
          keepMonthly = 12;
        };
        location = {
          patterns = [
            "R /persistent/data"
            "- ${localrepo}"
          ];
          repositories = [ localrepo ];
        };
      };
    };
  };
}
