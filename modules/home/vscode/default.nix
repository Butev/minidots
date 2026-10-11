{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  dotsVscode = "${inputs.cathe-dots}/modules/home/vscode";
  globalSettings = import "${dotsVscode}/settings/global";
  globalKeybindings = import "${dotsVscode}/keybindings.nix";
  vscodeLib = import "${dotsVscode}/lib.nix" {inherit lib globalSettings globalKeybindings;};

  features = builtins.mapAttrs (_: path: import path {inherit pkgs config;}) {
    nix = "${dotsVscode}/features/nix.nix";
    git = "${dotsVscode}/features/git.nix";
    markdown = "${dotsVscode}/features/markdown.nix";
    better-comments = "${dotsVscode}/features/better-comments.nix";
    json = "${dotsVscode}/features/json.nix";
    kdl = "${dotsVscode}/features/kdl.nix";
    theme = "${dotsVscode}/features/theme.nix";
    utils = "${dotsVscode}/features/utils.nix";
    claude = "${dotsVscode}/features/claude.nix";
    latex = "${dotsVscode}/features/latex.nix";
    java = "${dotsVscode}/features/java.nix";
    python = "${dotsVscode}/features/python.nix";
    vsrocq = "${dotsVscode}/features/vsrocq.nix";
    ocaml = "${dotsVscode}/features/ocaml.nix"; # rocqGroup extends ocamlGroup - needed even though not asked for by name
    disable-breakpoint = "${dotsVscode}/features/disable-breakpoint.nix";
    unicode-math-symbols = "${dotsVscode}/features/unicode-math-symbols.nix";
  };

  groups = import "${dotsVscode}/groups.nix" {inherit features;};
in {
  programs.vscode = {
    enable = true;
    # Standalone home-manager has no path to NixOS's security.wrappers, so the
    # nix-store vscode binary can't use Electron's setuid sandbox helper and
    # refuses to launch at all without this - same fix cathe's own config
    # uses (modules/home/vscode/default.nix), for the same underlying reason.
    package = pkgs.symlinkJoin {
      name = "vscode-no-sandbox";
      paths = [pkgs.vscode];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''wrapProgram $out/bin/code --add-flags "--no-sandbox"'';
    };
    mutableExtensionsDir = false; # required once any non-default profile exists
    profiles = {
      default = (vscodeLib.mkProfile groups.default).profile;
      java = (vscodeLib.mkProfile groups.java).profile;
      python = (vscodeLib.mkProfile groups.python).profile;
      rocq = (vscodeLib.mkProfile groups.rocq).profile;
    };
  };
}
