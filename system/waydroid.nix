{ minimal, ... }:
if (!minimal) then
  {
    virtualisation.waydroid.enable = true;
  }
else
  { }
