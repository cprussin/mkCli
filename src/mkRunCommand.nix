{callPackage}: let
  colors = callPackage ./colors.nix {};
  util = callPackage ./util.nix {};

  commandColors = [
    colors.red
    colors.green
    colors.yellow
    colors.blue
    colors.purple
    colors.cyan
    colors.brightRed
    colors.brightGreen
    colors.brightYellow
    colors.brightBlue
    colors.brightPurple
    colors.brightCyan
    colors.boldRed
    colors.boldGreen
    colors.boldYellow
    colors.boldBlue
    colors.boldPurple
    colors.boldCyan
    colors.boldBrightRed
    colors.boldBrightGreen
    colors.boldBrightYellow
    colors.boldBrightBlue
    colors.boldBrightPurple
    colors.boldBrightCyan
  ];

  defaultColor = colors.blue;

  prefixStr = prefix: index: let
    prefixColor =
      if index == -1
      then defaultColor
      else util.elemAtMod commandColors index;
  in " ${prefixColor prefix} ${colors.boldWhite "│"} ";
in
  cmd: prefix: index: "${cmd} \"$@\" 2>&1 | sed \"s/^/$(printf \"${prefixStr prefix index}\")/\""
