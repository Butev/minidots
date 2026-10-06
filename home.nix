{pkgs, ...}: {
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "25.11";

  # Required for standalone home-manager
  programs.home-manager.enable = true;

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
