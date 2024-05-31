{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
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
        pkgs = import nixpkgs { inherit system; };
        papermod = pkgs.fetchFromGitHub {
          owner = "adityatelange";
          repo = "hugo-PaperMod";
          rev = "v7.0";
          hash = "sha256-33EnCEvTxZYn31fxZkYJlQXvJsczXMVufSj6QJJHrLk=";
        };
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
