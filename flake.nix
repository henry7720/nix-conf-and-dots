{
  description = "Unified NixOS and Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }@inputs: {
    nixosConfigurations = {
      # Matches networking.hostName = "nixos" in configuration.nix
      nixos-yoga = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.henry = ./home.nix;
              sharedModules = [ nix-flatpak.homeManagerModules.nix-flatpak ];
            };
          }
        ];
      };
    };
  };
}
