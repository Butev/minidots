{
  description = "Standalone home-manager config for a new user";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cathe-dots = {
      url = "github:thecathe/dots";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # vscode extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    cathe-dots,
    nix-vscode-extensions,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    homeConfigurations."max@nixos-laptop" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        # config.allowUnfreePredicate = unfreePredicate;
        config.allowUnfree = true;
        overlays = [
          inputs.nix-vscode-extensions.overlays.default
        ];
      };
      extraSpecialArgs = {inherit inputs;};
      modules = [./home.nix];
    };
  };
}
