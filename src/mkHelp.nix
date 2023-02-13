{callPackage}: let
  util = callPackage ./util.nix {};
  styles = callPackage ./styles.nix {};

  echo = str: "echo -e '${str}'";

  mkHelpOption = option: value:
    if builtins.isAttrs value
    then [(styles.leaf option)] ++ (mkHelpOptions value)
    else ["${styles.branch option}: ${styles.command value}"];

  mkHelpOptions = options:
    util.indent (util.concatMapAttrsToList mkHelpOption options);
in
  cmd: options:
    map echo (
      [
        "Usage: ${cmd} <option>"
        ""
        (styles.sectionHead "Possible options:")
      ]
      ++ (mkHelpOptions options)
    )
