[![Bors enabled](https://bors.tech/images/badge_small.svg)](https://app.bors.tech/repositories/33905)
[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit]
[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)

> #### ⚠ Advisory ⚠
> DevOS requires the [flakes][flakes] feature available via an _experimental_
> branch of [nix][nix]. Until nix 3.0 is released, this project
> should be considered unstable, though quite usable as flakes have been
> maturing _well_ [for a while](https://github.com/divnix/devos/tree/17713c22d07c54525c728c62060a0428b76dee3b).


Digga is the underlying library implementation for the
[DevOS template](https://github.com/divnix/devos). There is an API to create
productive personal and professional flakes in a clean and organized manner.
By using this library your creations will be part of a community-first sharing
model.

# Usage
The best way to make use of library is with the [Official template](https://github.com/divnix/devos).
The primary function to make use of is `mkFlake` to create your devos flake.
To learn about `mkFlake`'s options, take a look at the [mkFlake options doc](./doc/mkFlakeOptions.md)

This library is based on [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus).

# Contributing
We encourage contributions of any kind. The simplest way to get involved is to
start posting your opinions on the issue or discussion threads. To craft well
thought out APIs we need all the thoughts regarding new ideas.

Pull Requests are just as amazing. To keep the library stable, all changes should
target the `develop` branch. Only minor bug-fixes or release PRs can target master.

# License
Digga is licensed under the [MIT License][mit].

[nix]: https://nixos.org/manual/nix/stable
[mit]: https://mit-license.org
[flakes]: https://nixos.wiki/wiki/Flakes


