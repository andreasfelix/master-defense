{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.accpkgs.url = "github:nobeam/accpkgs";

  outputs = { self, nixpkgs, flake-utils, accpkgs }:
    flake-utils.lib.eachDefaultSystem (system: with nixpkgs.legacyPackages.${system};
    {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = [
          python39Full
          poetry
          gcc
          curl
          jless
        ];
        shellHook = ''
          export PATH=$PWD/bin:$PATH
        '';
        RPN_DEFNS = accpkgs.packages.${system}.epics.defns_rpn;
        LD_LIBRARY_PATH = lib.makeLibraryPath [
          stdenv.cc.cc.lib
          zlib
          # elegant
          gsl
          openblas
          readline
        ];
      };
    });
}
