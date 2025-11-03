{
  description = "A simple, strong Haskell project with Nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        haskellPackages = pkgs.haskellPackages;

        # Define the Haskell package
        myHaskellPackage = haskellPackages.callCabal2nix "haskell-project" ./. { };

      in
      {
        # The default package
        packages.default = myHaskellPackage;

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with haskellPackages; [
            ghc
            cabal-install
            haskell-language-server
            ghcid
            hlint
            ormolu
          ];

          inputsFrom = [ myHaskellPackage.env ];

          shellHook = ''
            echo "Haskell development environment"
            echo "GHC version: $(ghc --version)"
            echo "Cabal version: $(cabal --version | head -n1)"
            echo ""
            echo "Available commands:"
            echo "  cabal build    - Build the project"
            echo "  cabal run      - Run the project"
            echo "  cabal repl     - Start GHCi REPL"
            echo "  ghcid          - Continuous build/test"
            echo "  hlint .        - Lint Haskell code"
            echo "  ormolu -i      - Format Haskell code"
          '';
        };

        # Apps that can be run with 'nix run'
        apps.default = {
          type = "app";
          program = "${myHaskellPackage}/bin/haskell-project";
        };
      }
    );
}
