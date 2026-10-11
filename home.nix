{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    "${inputs.cathe-dots}/modules/home/shell"
    "${inputs.cathe-dots}/modules/home/nvim"
    ./modules/home
  ];

  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "25.11";

  # Required for standalone home-manager
  programs.home-manager.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Butev";
      email = "utevb1@gmail.com";
    };
  };

  home.packages = with pkgs; [
    wget
    fzf
    git
    gh
    tmux
    nix
    nixfmt
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
