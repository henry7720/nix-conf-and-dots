{
  description = "Unified NixOS and Home Manager Flake";
  # for using flakes and NO channels:
  # sudo nix-channel --list
  # sudo nix-channel --remove nixos
  # sudo rm -f /nix/var/nix/profiles/per-user/root/channels* /root/.nix-channels
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      lanzaboote,
      home-manager,
      nix-flatpak,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # Matches networking.hostName = "nixos" in configuration.nix
        nixos-yoga = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix

            lanzaboote.nixosModules.lanzaboote

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                backupFileExtension = "backup";
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.henry = ./home.nix;
                # sharedModules = [ nix-flatpak.homeManagerModules.nix-flatpak ];
              };
            }
          ];
        };
      };
    };
}
