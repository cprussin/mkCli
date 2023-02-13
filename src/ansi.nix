{lib}: {
  style = effects: text: "\\033[${lib.concatStringsSep ";" effects}m${text}\\033[0m";

  reset = "0";

  bold = "1";
  underline = "4";

  fgBlack = "30";
  fgRed = "31";
  fgGreen = "32";
  fgYellow = "33";
  fgBlue = "34";
  fgPurple = "35";
  fgCyan = "36";
  fgLightGrey = "37";
  fgDarkGrey = "90";
  fgBrightRed = "91";
  fgBrightGreen = "92";
  fgBrightYellow = "93";
  fgBrightBlue = "94";
  fgBrightPurple = "95";
  fgBrightCyan = "96";
  fgWhite = "97";

  bgBlack = "40";
  bgRed = "41";
  bgGreen = "42";
  bgYellow = "43";
  bgBlue = "44";
  bgPurple = "45";
  bgCyan = "46";
  bgLightGrey = "47";
  bgDarkGrey = "100";
  bgBrightRed = "101";
  bgBrightGreen = "102";
  bgBrightYellow = "103";
  bgBrightBlue = "104";
  bgBrightPurple = "105";
  bgBrightCyan = "106";
  bgWhite = "107";
}
