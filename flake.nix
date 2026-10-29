{
  description = "Standalone home-manager config for a new user";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # cathe's shared config. Used through its `homeModules` (shell, nvim,
    # vscode, globalprotect), which carry what they need from dots' own inputs
    # (e.g. the vscode extensions), so nothing else is added here. Pick up
    # changes with `nix flake update cathe-dots`.
    cathe-dots = {
      url = "github:thecathe/dots";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    homeConfigurations."max@nixos-laptop" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        # config.allowUnfreePredicate = unfreePredicate;
        config.allowUnfree = true;
      };
      extraSpecialArgs = {inherit inputs;};
      modules = [./home.nix];
    };
  };
}
