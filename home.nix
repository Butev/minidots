{
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs.cathe-dots.homeModules; [
    shell
    nvim
    vscode
    globalprotect
  ];

  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "25.11";

  # Required for standalone home-manager
  programs.home-manager.enable = true;

  # VS Code with cathe's settings, keybindings and extensions. The default
  # profile is always built; these are the others. To add or drop one, edit
  # the list (the names are those in dots' modules/home/vscode/groups.nix).
  dots.vscode = {
    enable = true;
    profiles = ["java" "python" "rocq" "haskell"];
  };

  # The University of Kent's VPN: `globalprotect up | down | status`. `up`
  # asks for your sudo password (the tunnel needs root), opens the browser to
  # log in, and then stays running in that terminal until Ctrl-C or
  # `globalprotect down`.
  dots.globalprotect = {
    enable = true;
    portal = "vox.kent.ac.uk";
  };

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
    nixd # Nix language server, started by name from VS Code and neovim
    alejandra # the formatter those editors (and nixd) call
    discord # unfree, allowed by config.allowUnfree in flake.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
