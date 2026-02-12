{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/x86_64-linux";

    disko = {
      url = "github:nix-community/disko/v1.12.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-extensions = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
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
    private = {
      url = "git+ssh://git@github.com/Luk-ESC/private_config?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    copai = {
      url = "github:inet4/copai";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.firefox-extensions.follows = "firefox-extensions";
    };

    leaves = {
      url = "github:Luk-ESC/leaves";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
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
      private,
      fenix,
      wallpapers,
      niri,
      pwndbg,
      copai,
      leaves,
      ...
    }:
    let
      mkSystem =
        minimal:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit minimal; };
          modules = [
            # Import the previous configuration.nix we used,
            # so the old configuration file still takes effect
            ./system/configuration.nix
            ./hardware-configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.eschb =
                { ... }:
                {
                  imports = [
                    ./home
                    ./persist/home.nix
                  ];
                };

              home-manager.extraSpecialArgs = {
                inherit wallpapers minimal;
                extensions = firefox-extensions.packages.${system};
                pwndbg = pwndbg.packages.${system}.default;
                ida91 = private.packages.${system}.ida91;
                age = agenix.packages.${system}.default;
                copai = copai.packages.${system}.default;
              };

              home-manager.sharedModules = [
                stylix.homeModules.stylix
                agenix.homeManagerModules.default
              ];
            }

            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [ fenix.overlays.default ];
            }

            {
              stylix.image = (wallpapers.outPath + "/default");
            }

            stylix.nixosModules.stylix
            niri.nixosModules.niri

            leaves.nixosModules.${system}.default

            disko.nixosModules.disko
            ./disko/disko-config.nix

            impermanence.nixosModules.impermanence
            ./system/impermanence.nix

            ./persist/persist.nix
            ./persist/conf.nix

            agenix.nixosModules.default
            secrets.nixosModules.default
            private.nixosModules.default

            {
              age.identityPaths = [ "/persistent/data/home/eschb/nixcfg/keys/id_ed25519" ];
            }
          ];
        };
    in
    {
      nixosConfigurations.nixos = mkSystem false;
      nixosConfigurations.minimal = mkSystem true;
      nixosConfigurations.base = nixpkgs.lib.nixosSystem rec {
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

              isoImage.storeContents = [ self.nixosConfigurations.minimal.config.system.build.toplevel ];

              environment.systemPackages = [
                disko.packages.${system}.disko-install

                (pkgs.writeShellScriptBin "install-with-disko" (builtins.readFile ./scripts/install-with-disko.sh))
              ];
            }
          )
          ./system/base.nix
        ];
      };
    };
}
