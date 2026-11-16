# This machine's own tuning of the VS Code that dots sets up. `dots.vscode` (in
# ../../../home.nix) turns it on and picks the profiles; the files imported
# here change what comes out of it, without touching dots.
#
# How it works: dots builds each profile's settings.json from its features and
# hands it to home-manager as `programs.vscode.profiles.<name>.userSettings`.
# Setting that same option here merges with dots' value, so a file only needs
# the settings it wants to change, under VS Code's own names (the Settings UI
# shows them). Whatever dots does not set just works. Where dots does set a key:
#   - a list is added to, or replaced if yours is wrapped in `lib.mkForce`;
#   - a plain value is a "conflicting definition values" error unless yours is
#     wrapped in `lib.mkForce`.
# Profile names are those in dots' modules/home/vscode/groups.nix. Some of
# dots' settings are written nested (`"editor" = {...}` inside `"[latex]"`) and
# some flat (`"ltex.enabled"`); override a key in the shape dots wrote it: a flat
# key set beside a nested one does not replace it, and both land in the file.
#
# To tune another part, add a file next to ltex.nix (python.nix, say) and list
# it here.
{
  imports = [
    ./ltex.nix
  ];
}
