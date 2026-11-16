# Your own settings for the latex profile's grammar and spell checker (LTeX+).
# dots installs it and sets what it needs to run (its server, its Java, and the
# file types it checks); how it checks is yours. Uncomment and edit the lines
# below, or add your own: search "ltex" in VS Code's Settings UI for the names.
#
# Of the LTeX+ settings, dots sets three, so for those:
#   - `ltex.enabled` is a list: yours is added to dots', or wrap yours in
#     `lib.mkForce` to replace it;
#   - `ltex.java.path` and `ltex.ltex-ls.path` are plain values: leave them
#     alone, or use `lib.mkForce` (say, to point at a different Java).
# Every other `ltex.*` setting just works, including nested ones like the
# dictionary.
#
# LTeX+ is only in the latex profile, and the guard stops a bare, empty `latex`
# profile appearing if "latex" is dropped from `dots.vscode.profiles`.
{
  config,
  lib,
  ...
}: {
  programs.vscode.profiles = lib.mkIf (lib.elem "latex" config.dots.vscode.profiles) {
    latex.userSettings = {
      # "ltex.language" = "en-GB";
      # "ltex.additionalRules.enablePickyRules" = true;
      # "ltex.additionalRules.motherTongue" = "en-GB";
      # "ltex.dictionary"."en-GB" = ["Hoare" "bisimulation"];
      # "ltex.disabledRules"."en-GB" = ["SENTENCE_WHITESPACE"];
      # "ltex.latex.commands"."\\todo{}" = "ignore";
      # "ltex.latex.environments"."proof" = "ignore";
    };
  };
}
