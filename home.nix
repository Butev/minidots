{
  config,
  lib,
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
    profiles = ["java" "python" "rocq" "haskell" "ocaml" "latex"];
  };

  # Where nixd (the Nix language server in VS Code and neovim) finds this
  # flake: it completes home-manager options from it and takes nixpkgs from
  # its `nixpkgs` input. The real path of the clone, not the ~/dots link,
  # because builtins.getFlake rejects symlinks.
  dots.nixd = {
    flake = "${config.home.homeDirectory}/Documents/git/Butev/minidots";
    homeConfiguration = "max@nixos-laptop";
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
      # The email is deliberately not in this (public) repo: git reads it from
      # the file included below, made once per machine (see the README). Until
      # then a commit fails, instead of git guessing an address from the
      # hostname.
      useConfigOnly = true;
    };
    includes = [{path = "${config.home.homeDirectory}/.config/git/identity";}];
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
    zotero # citation manager
  ];

  # TEMPORARY. Zotero 10 only builds against Firefox 140 ESR, which is
  # end-of-life, so flake.nix permits that one package as insecure. Zotero 11
  # is meant to move to Firefox ESR 153; when nixpkgs gets it, this fails the
  # rebuild so the exception does not linger unnoticed.
  assertions = [
    {
      assertion = lib.versionOlder pkgs.zotero.version "11";
      message = ''
        nixpkgs now has Zotero ${pkgs.zotero.version}, which should no longer need the
        end-of-life Firefox 140 ESR, so the temporary exception for it can go:

          1. flake.nix: remove `config.permittedInsecurePackages` (the
             "firefox-esr-140-bin-unwrapped-..." entry) from the nixpkgs import.
          2. home.nix: delete this assertion (the `assertions` block).
          3. README.md: delete the "Zotero and the end-of-life Firefox" section.
          4. Rebuild. If it still fails with "marked as insecure", Zotero ${pkgs.zotero.version}
             is still on Firefox 140: check `nix log` and nixpkgs'
             pkgs/by-name/zo/zotero/package.nix, then raise the version in this
             assertion instead.

        Nothing in cathe-dots (the shared modules) needs to change; Zotero lives
        only in this repo.
      '';
    }
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
