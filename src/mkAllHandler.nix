{
  callPackage,
  lib,
}: let
  ansi = callPackage ./ansi.nix {};
  mkRunCommand = callPackage ./mkRunCommand.nix {};
  styles = callPackage ./styles.nix {};
  util = callPackage ./util.nix {};

  getSubcommandsWithNames = prefix: subcommand: value: let
    prefixWithSubcommand = "${prefix} ${subcommand}";
  in
    if lib.isString value || lib.isStorePath value
    then [(lib.nameValuePair prefixWithSubcommand value)]
    else getCommandsWithNames prefixWithSubcommand value;

  getCommandsWithNames = prefix:
    util.concatMapAttrsToList (getSubcommandsWithNames prefix);

  pidEnvVar = pos: "PID_${toString pos}";
  statusEnvVar = pos: "STATUS_${toString pos}";

  commandColors = [
    ansi.fgYellow
    ansi.fgBlue
    ansi.fgPurple
    ansi.fgCyan
    ansi.fgBrightRed
    ansi.fgBrightGreen
    ansi.fgBrightYellow
    ansi.fgBrightBlue
    ansi.fgBrightPurple
    ansi.fgBrightCyan
  ];

  prefixStyle = pos: ansi.style [(util.elemAtMod commandColors pos)];

  separator = ["echo" "echo" "echo"];

  mkInitSummary = commandsByName: let
    mkCommandPreview = pos: name: "echo -e \"   ${prefixStyle pos name}: ${styles.command commandsByName."${name}"}\"";
  in
    ["echo -e \" ${styles.sectionHead "Running Scripts:"}\""]
    ++ (lib.imap0 mkCommandPreview (builtins.attrNames commandsByName));

  mkJobs = commandsByName: let
    commandNames = builtins.attrNames commandsByName;
    maxNameLength = util.maxSet (map builtins.stringLength commandNames);
    padName = util.exactWidthString maxNameLength;
    mkCommand = pos: name:
      [
        "{"
      ]
      ++ (
        util.indent (
          mkRunCommand true commandsByName."${name}" (prefixStyle pos (padName name))
        )
      )
      ++ [
        "} &"
        "${pidEnvVar pos}=$!"
      ];
  in
    lib.concatLists (lib.imap0 mkCommand commandNames);

  mkWait = pos: _: [
    "wait \$${pidEnvVar pos}"
    "${statusEnvVar pos}=$?"
  ];

  mkWaits = commandsByName:
    lib.concatLists (lib.imap0 mkWait (builtins.attrNames commandsByName));

  summarize = pos: name: [
    "if [ \$${statusEnvVar pos} == 0 ]; then"
    "  echo -e \"   ✅ ${styles.success name}\""
    "else"
    "  echo -e \"   ❌ ${styles.fail name} (code $STATUS_${toString pos})\""
    "fi"
  ];

  mkEndSummary = commandsByName:
    ["echo -e \" ${styles.sectionHead "Summary"}\""]
    ++ (lib.concatLists (lib.imap0 summarize (builtins.attrNames commandsByName)));

  mkExitFor = pos: [
    "if [ \$${statusEnvVar pos} != 0 ]; then"
    "  exit \$${statusEnvVar pos}"
    "fi"
  ];

  mkExit = commandsByName:
    lib.concatLists (
      lib.imap0 (pos: _: mkExitFor pos) (builtins.attrNames commandsByName)
    );
in
  prefix: options: let
    commandsByName = builtins.listToAttrs (getCommandsWithNames prefix options);
  in
    (mkInitSummary commandsByName)
    ++ separator
    ++ (mkJobs commandsByName)
    ++ (mkWaits commandsByName)
    ++ separator
    ++ (mkEndSummary commandsByName)
    ++ (mkExit commandsByName)
