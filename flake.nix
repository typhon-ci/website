{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    papermod = {
      url = "github:adityatelange/hugo-papermod";
      flake = false;
    };
    typhon.url = "github:typhon-ci/typhon";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      papermod,
      typhon,
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
    )
    // {
      typhonJobs = typhon.lib.eachSystem (system: {
        inherit (self.packages.${system}) default;
      });
      typhonProject =
        let
          owner = "typhon-ci";
          repo = "website";
        in
        typhon.lib.github.mkProject {
          inherit owner repo;
          secrets = ./flake.nix; # not used
          typhonUrl = "https://example.org";
          deploy = [
            {
              name = "deploy website";
              value = typhon.lib.github.mkPages {
                inherit owner repo;
                job = "default";
                customDomain = "typhon-ci.org";
              };
            }
          ];
        };
    };
}
