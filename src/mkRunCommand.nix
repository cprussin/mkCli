{callPackage}: let
  ansi = callPackage ./ansi.nix {};

  prefixStr = prefix: " ${prefix} ${ansi.style [ansi.fgDarkGrey] "│"} ";
in
  prefixOutputs: cmd: prefix:
    if prefixOutputs
    then [
      "${cmd} \"$@\" 2>&1 | sed \"s/^/$(printf \"${prefixStr prefix}\")/\""
      "exit \${PIPESTATUS[0]}"
    ]
    else ["${cmd}"]
