{
  callPackage,
  lib,
}: let
  mkRunCommand = callPackage ./mkRunCommand.nix {};
  util = callPackage ./util.nix {};

  getSubcommandsWithNames = prefix: subcommand: value: let
    prefixWithSubcommand = "${prefix} ${subcommand}";
  in
    if builtins.isString value
    then [(lib.nameValuePair prefixWithSubcommand value)]
    else getCommandsWithNames prefixWithSubcommand value;

  getCommandsWithNames = prefix:
    util.concatMapAttrsToList (getSubcommandsWithNames prefix);

  commands = prefix: options: let
    commandsByName = builtins.listToAttrs (getCommandsWithNames prefix options);
    commandNames = builtins.attrNames commandsByName;
    maxNameLength = util.maxSet (map builtins.stringLength commandNames);
    padName = util.exactWidthString maxNameLength;
    mkCommand = pos: name: "${mkRunCommand commandsByName."${name}" (padName name) pos} &";
  in
    lib.imap0 mkCommand commandNames;
in
  prefix: options:
    (lib.concatLists (map (cmd: [cmd "pids+=($!)"]) (commands prefix options)))
    ++ ["for pid in \${pids[*]}; do wait $pid; done"]
