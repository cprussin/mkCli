{
  callPackage,
  lib,
  writeShellScriptBin,
}: let
  colors = callPackage ./colors.nix {};
  mkAllHandler = callPackage ./mkAllHandler.nix {};
  mkHelp = callPackage ./mkHelp.nix {};
  mkRunCommand = callPackage ./mkRunCommand.nix {};
  util = callPackage ./util.nix {};

  unknownOptionErrorMesage = "${colors.boldRed "Error: Unknown option"} ${colors.lightGrey "$option"}\n";

  mkCase = key: value:
    if builtins.isString value
    then ["${key}) ${value} ;;"]
    else ["${key})"] ++ (util.indent (value ++ [";;"]));

  mkSubcommandHandler = prefix: subcommand: value: let
    prefixWithSubcommand = "${prefix} ${subcommand}";
  in
    mkCase subcommand (
      if builtins.isString value
      then mkRunCommand value prefixWithSubcommand (-1)
      else mkOptions prefixWithSubcommand value
    );

  mkOptions = prefix: options: let
    options' = builtins.removeAttrs options ["_noAll"];
    subcommands =
      util.concatMapAttrsToList (mkSubcommandHandler prefix) options';
    all =
      if options._noAll or false
      then []
      else mkCase "all|''" (mkAllHandler prefix options');
    help = mkCase "-h|--help|''" (mkHelp prefix options');
    unknownOptionError = mkCase "*" (
      ["echo -e \"${unknownOptionErrorMesage}\" >&2"]
      ++ (mkHelp prefix options')
      ++ ["exit 1"]
    );
  in
    [
      "option=\"$1\""
      "shift || true"
      "case \"$option\" in"
    ]
    ++ (util.indent (subcommands ++ all ++ help ++ unknownOptionError))
    ++ ["esac"];
in
  name: options:
    writeShellScriptBin name ''
      set -e
      set -o pipefail

      ${lib.concatStringsSep "\n" (mkOptions name options)}
    ''
