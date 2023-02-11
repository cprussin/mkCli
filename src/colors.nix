_: let
  mkAnsiColorFn = code: text: "\\033[${code}m${text}\\033[0m";
in {
  black = mkAnsiColorFn "0;30";
  red = mkAnsiColorFn "0;31";
  green = mkAnsiColorFn "0;32";
  yellow = mkAnsiColorFn "0;33";
  blue = mkAnsiColorFn "0;34";
  purple = mkAnsiColorFn "0;35";
  cyan = mkAnsiColorFn "0;36";
  lightGrey = mkAnsiColorFn "0;37";
  darkGrey = mkAnsiColorFn "0;90";
  brightRed = mkAnsiColorFn "0;91";
  brightGreen = mkAnsiColorFn "0;92";
  brightYellow = mkAnsiColorFn "0;93";
  brightBlue = mkAnsiColorFn "0;94";
  brightPurple = mkAnsiColorFn "0;95";
  brightCyan = mkAnsiColorFn "0;96";
  white = mkAnsiColorFn "0;97";

  boldBlack = mkAnsiColorFn "1;30";
  boldRed = mkAnsiColorFn "1;31";
  boldGreen = mkAnsiColorFn "1;32";
  boldYellow = mkAnsiColorFn "1;33";
  boldBlue = mkAnsiColorFn "1;34";
  boldPurple = mkAnsiColorFn "1;35";
  boldCyan = mkAnsiColorFn "1;36";
  boldLightGrey = mkAnsiColorFn "1;37";
  boldDarkGrey = mkAnsiColorFn "1;90";
  boldBrightRed = mkAnsiColorFn "1;91";
  boldBrightGreen = mkAnsiColorFn "1;92";
  boldBrightYellow = mkAnsiColorFn "1;93";
  boldBrightBlue = mkAnsiColorFn "1;94";
  boldBrightPurple = mkAnsiColorFn "1;95";
  boldBrightCyan = mkAnsiColorFn "1;96";
  boldWhite = mkAnsiColorFn "1;97";
}
