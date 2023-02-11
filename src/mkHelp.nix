{callPackage}: let
  colors = callPackage ./colors.nix {};
  util = callPackage ./util.nix {};

  echo = str: "echo -e '${str}'";

  mkHelpOption = option: value:
    if builtins.isString value
    then ["${colors.boldWhite "${option}:"} ${value}"]
    else [option] ++ (mkHelpOptions value);

  mkHelpOptions = options:
    util.indent (util.concatMapAttrsToList mkHelpOption options);
in
  cmd: options:
    map echo (
      [
        "Usage: ${cmd} <option>"
        ""
        "Possible options:"
      ]
      ++ (mkHelpOptions options)
    )
