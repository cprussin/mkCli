self: super: {
  lib =
    super.lib
    // {
      mkCli = self.callPackage ./. {};
    };
}
