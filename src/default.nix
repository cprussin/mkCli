{
  callPackage,
  lib,
  writeShellScriptBin,
}: let
  mkAllHandler = callPackage ./mkAllHandler.nix {};
  mkHelp = callPackage ./mkHelp.nix {};
  mkRunCommand = callPackage ./mkRunCommand.nix {};
  styles = callPackage ./styles.nix {};
  util = callPackage ./util.nix {};

  mkCase = key: value:
    if lib.isString value || lib.isStorePath value
    then ["${key}) ${value} ;;"]
    else ["${key})"] ++ (util.indent (value ++ [";;"]));

  mkSubcommandHandler = prefix: subcommand: value: let
    prefixWithSubcommand = "${prefix} ${subcommand}";
  in
    mkCase subcommand (
      if lib.isString value || lib.isStorePath value
      then mkRunCommand false value (styles.defaultCommandColor prefixWithSubcommand)
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
      ["echo -e \"${styles.error "Error: Unknown option"} ${styles.errorContext "$option"}\\n\" >&2"]
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
    writeShellScriptBin name (lib.concatStringsSep "\n" (mkOptions name options))
