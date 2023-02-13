{
  callPackage,
  lib,
}: let
  util = callPackage ./util.nix {};
  styles = callPackage ./styles.nix {};

  echo = str: "echo -e '${str}'";

  mkHelpOption = option: value:
    if lib.isStringLike value
    then ["${styles.branch option}: ${styles.command value}"]
    else [(styles.leaf option)] ++ (mkHelpOptions value);

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
