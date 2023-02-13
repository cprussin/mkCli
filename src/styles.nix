{callPackage}: let
  ansi = callPackage ./ansi.nix {};
in {
  branch = ansi.style [ansi.bold];
  leaf = ansi.style [ansi.bold ansi.fgBlue];
  command = ansi.style [ansi.fgDarkGrey];
  sectionHead = ansi.style [ansi.bold ansi.fgWhite];
  success = ansi.style [ansi.fgGreen];
  fail = ansi.style [ansi.fgRed];
  error = ansi.style [ansi.bold ansi.fgRed];
  errorContext = ansi.style [ansi.fgLightGrey];
  defaultCommandColor = ansi.style [ansi.fgBlue];
}
