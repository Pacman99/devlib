{ lib, deploy }:
{
  mkHomeConfigurations = nixosConfigurations:
    with lib;
    let
      mkHomes = host: config:
        mapAttrs' (user: v: nameValuePair "${user}@${host}" v.home)
          config.config.system.build.homes;

      hmConfigs = mapAttrs mkHomes nixosConfigurations;

    in
    foldl recursiveUpdate { } (attrValues hmConfigs);

  mkDeployNodes = hosts: extraConfig:
    /**
      Synopsis: mkNodes _nixosConfigurations_

      Generate the `nodes` attribute expected by deploy-rs
      where _nixosConfigurations_ are `nodes`.
      **/
    let
      # Any nixpkgs instance can be used, deploy only needs trivial builders
      pkgs = (builtins.head (builtins.attrValues hosts)).pkgs.appendOverlays [ deploy.overlay ];
    in
    lib.mapAttrs
      (_: config:
        lib.recursiveUpdate
          {
            hostname = config.config.networking.hostName;

            profiles.system = {
              user = "root";
              path = pkgs.deploy-rs.lib.activate.nixos config;
            };
          }
          extraConfig)
      hosts;

  # DEPRECATED, suites no longer needs an explicit function after the importables generalization
  # deprecation message for suites is already in evalArgs
  mkSuites = { suites, profiles }:
    let
      profileSet = lib.genAttrs' profiles (path: {
        name = baseNameOf path;
        value = lib.mkProfileAttrs (toString path);
      });
    in
    lib.mapAttrs (_: v: lib.profileMap v) (suites profileSet);
}
