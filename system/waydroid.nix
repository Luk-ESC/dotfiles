{ minimal, ... }:
if (!minimal) then
  {
    virtualisation.waydroid.enable = true;

    persist.location.logs.contents = [
      "/var/lib/waydroid/waydroid.log"
    ];

    persist.location.session.contents = [
      "/var/lib/waydroid/"
    ];
  }
else
  { }
