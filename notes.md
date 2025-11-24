To rebuild:
sudo nixos-rebuild switch --flake .#nixos


https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes#the-new-cli-and-the-classic-cli
All commands with - in them are outdated.
ie. use `nix shell` rather than `nix-shell`. The `nix` command is for flakes.
'Channels' are also unnecessary, replaced by `inputs` section of flakes

flake.nix is the entrypoint of the build. It's like cargo.toml on some level.
A flake is (roughly) just a description of a file system


# Difference `programs.PROGRAM_NAME.enable = true;` vs `environment.systemPackages = [ pkgs.PROGRAM_NAME ];`
To answer your original question, generally the ‘.enable = true’ options are preferred as they will be smart about a system effects which are needed to the application/service to run correctly. For example, ‘virtualization.docker.enable = true’ will create the necessary groups, install the docker-daemon, install the docker cli, and a few other things to enable normal docker usage.

# TODO: Write a shell script which puts helix into the config dir, and a second one which rebuilds. Alternatively, maybe pushd is good enough?


In nix packages, stuff like this here: `{ lib, buildPythonPackage, python3Packages, setuptools }:` is function arguments.
Of course, you never see these function arguments "filled in" anywhere. Why does this work? Because all function arguments are NAMED by default.
So in other words, a package with such a first line says "You can only call me with a set containing exactly these named parameters."
Example:
```nix
let concat = { x, y }: x + y;
in concat { x = "foo"; y = "bar"; }
```
Here `let ... in ...` says "define this variable in this expression." Aka 1. define concact, give it a name, 2. the expression following `in` has concat in its scope

So how does it make sense that the function can only be called with EXACTLY those arguments, when in eg. shell.nix files I can write:
```nix
  python = pkgs.python3.override {
    self = python;
    packageOverrides = pyfinal: pyprev: {
      hitherdither = pyfinal.callPackage ./hitherdither.nix { };
    };
  };
```
Aka using some weird `callPackage` instead of filling these values in? The answer is some weird reflection nonsense where "callPackage then iterates over those attribute names, fetches required packages and constucts the attrset of packages, that is fed later to called function."
I am not sure if I like this, it sounds like it just automatically grabs values from (presumably) the local scope to pass them in. I hope that it at least works as "obviously" as possible. Aka "if there exists a value 'foo' in the local scope, add `foo = foo` to the set used to call the function".


