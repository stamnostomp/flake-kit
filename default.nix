{ mkDerivation, base, lib }:
mkDerivation {
  pname = "flake-kit";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ];
  description = "small projram to help with managment of a nix system flake";
  license = lib.licenses.bsd3;
  mainProgram = "flake-kit";
}
