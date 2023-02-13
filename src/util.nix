{lib}: {
  indent = map (str: "  " + str);

  concatMapAttrsToList = fn: attrs:
    lib.concatLists (lib.mapAttrsToList fn attrs);

  exactWidthString = width: str:
    lib.fixedWidthString width " " (builtins.substring 0 width str);

  elemAtMod = set: index:
    builtins.elemAt set (lib.mod index (builtins.length set));

  maxSet = lib.fold lib.max 0;

  repeatString = str: count: lib.concatStringsSep "" (lib.genList (_: str) count);
}
