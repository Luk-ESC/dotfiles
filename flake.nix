{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/x86_64-linux";

    disko = {
      url = "github:nix-community/disko/v1.12.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence/home-manager-v2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-extensions = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
      inputs.darwin.follows = "";
    };

    secrets.url = "git+ssh://git@github.com/Luk-ESC/secrets?ref=main";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:Luk-ESC/wallpapers";
      flake = false;
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.niri-stable.follows = "";
      inputs.niri-unstable.follows = "";
      inputs.xwayland-satellite-stable.follows = "";
      inputs.xwayland-satellite-unstable.follows = "";
    };

    pwndbg = {
      url = "github:pwndbg/pwndbg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      impermanence,
      stylix,
      firefox-extensions,
      agenix,
      secrets,
      fenix,
      wallpapers,
      niri,
      pwndbg,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.eschb =
              { ... }:
              {
                imports = [
                  ./home
                  ./persist/home.nix
                  impermanence.homeManagerModules.impermanence
                ];
              };

            home-manager.extraSpecialArgs = {
              inherit wallpapers;
              extensions = firefox-extensions.packages.x86_64-linux;
              pwndbg = pwndbg.packages.x86_64-linux.default;
            };

            home-manager.sharedModules = [
              stylix.homeModules.stylix
              niri.homeModules.stylix
              agenix.homeManagerModules.default
            ];
          }

          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ fenix.overlays.default ];
          }

          niri.nixosModules.niri

          disko.nixosModules.disko
          ./disko/disko-config.nix

          impermanence.nixosModules.impermanence
          ./impermanence.nix

          ./persist/persist.nix
          ./persist/conf.nix

          agenix.nixosModules.default
          secrets.nixosModules.default

          {
            age.identityPaths = [ "/persistent/data/home/eschb/nixcfg/keys/id_ed25519" ];
          }
        ];
      };

      nixosConfigurations.base = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (
            { pkgs, modulesPath, ... }:
            {
              imports = [
                (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
              ];
              networking.wireless.enable = false;
              isoImage.squashfsCompression = "zstd";

              isoImage.contents = [
                {
                  source = self;
                  target = "/source";
                }
              ];

              isoImage.storeContents = [ self.nixosConfigurations.nixos.config.system.build.toplevel ];

              environment.systemPackages = [
                disko.packages.x86_64-linux.disko-install

                (pkgs.writeShellScriptBin "install-with-disko" (builtins.readFile ./scripts/install-with-disko.sh))
              ];
            }
          )
          ./base.nix
        ];
      };
    };
}
