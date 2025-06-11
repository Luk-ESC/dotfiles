{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/v1.12.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    impermanence.url = "github:nix-community/impermanence";
    panoptes = {
      url = "github:Luk-ESC/panoptes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    impermanence,
    plasma-manager,
    panoptes,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.eschb = ./home;
          home-manager.sharedModules = [plasma-manager.homeManagerModules.plasma-manager];
        }
        disko.nixosModules.disko
        ./disko/disko-config.nix

        impermanence.nixosModules.impermanence
        ./impermanence.nix

        ./persist/persist.nix
        ./persist/conf.nix

        panoptes.nixosModules.x86_64-linux.panoptes-service
        {
          environment.systemPackages = [(panoptes.defaultPackage.x86_64-linux)];
        }
      ];
    };

    nixosConfigurations.base = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({
          pkgs,
          modulesPath,
          ...
        }: {
          imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
          networking.wireless.enable = false;
          isoImage.squashfsCompression = "zstd";

          isoImage.contents = [
            {
              source = self;
              target = "/source";
            }
          ];

          isoImage.storeContents = [
            self.nixosConfigurations.nixos.config.system.build.toplevel
          ];

          environment.systemPackages = [
            disko.packages.x86_64-linux.disko-install

            (pkgs.writeShellScriptBin
              "install-with-disko"
              (builtins.readFile
                ./scripts/install-with-disko.sh))
          ];
        })
        ./base.nix
      ];
    };
  };
}
