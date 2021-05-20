{ lib, deploy }:
let
  getFqdn = c:
    let
      net = c.config.networking;
      fqdn =
        if net.domain != null
        then "${net.hostName}.${net.domain}"
        else net.hostName;
    in
    fqdn;

in
{
  mkHomeConfigurations = nixosConfigurations:
    /**
      Synopsis: mkHomeConfigurations _nixosConfigurations_

      Generate the `homeConfigurations` attribute expected by
      `home-manager` cli from _nixosConfigurations_ in the form
      _user@hostname_.
      **/
    let
      op = attrs: c:
        attrs
        //
        (
          lib.mapAttrs'
            (user: v: {
              name = "${user}@${getFqdn c}";
              value = v.home;
            })
            c.config.home-manager.users
        )
      ;
      mkHmConfigs = lib.foldl op { };
    in
    mkHmConfigs (builtins.attrValues nixosConfigurations);

  mkDeployNodes = hosts: extraConfig:
    /**
      Synopsis: mkNodes _nixosConfigurations_

      Generate the `nodes` attribute expected by deploy-rs
      where _nixosConfigurations_ are `nodes`.

      Example input:
      ```
      {
      hostname-1 = {
      fastConnection = true;
      sshOpts = [ "-p" "25" ];
      };
      hostname-2 = {
      sshOpts = [ "-p" "19999" ];
      sshUser = "root";
      };
      }
      ```
      **/

    lib.mapAttrs
      (_: config: lib.recursiveUpdate
        {
          hostname = config.config.networking.hostName;

          profiles.system = {
            user = "root";
            path = deploy.lib.${config.config.nixpkgs.system}.activate.nixos config;
          };
        }
        extraConfig)
      hosts;

  mkSuites = { suites, profiles }:
    let
      profileSet = lib.genAttrs' profiles (path: {
        name = baseNameOf path;
        value = lib.mkProfileAttrs (toString path);
      });

      definedSuites = suites profileSet;

      allProfiles = lib.collectProfiles profileSet;
    in
    lib.mapAttrs (_: v: lib.profileMap v) definedSuites // {
      inherit allProfiles;
    };
}
