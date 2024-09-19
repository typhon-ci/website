{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "flake-utils";
    papermod = {
      url = "github:adityatelange/hugo-papermod";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      papermod,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        website = pkgs.stdenv.mkDerivation {
          name = "website";
          src = ./.;
          postPatch = "mkdir themes && cp -r ${papermod} themes/papermod";
          nativeBuildInputs = [ pkgs.hugo ];
          buildPhase = "hugo";
          installPhase = "cp -r public $out";
        };
      in
      {
        packages.default = website;
        devShells.default = pkgs.mkShell { packages = [ pkgs.hugo ]; };
      }
    );
}
