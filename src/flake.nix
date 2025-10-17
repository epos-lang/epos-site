{
  description = "Epos lang docs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.writers.writePython3Bin "build-docs" {
          libraries =
            [ pkgs.python313Packages.pypandoc pkgs.python313Packages.jinja2 ];
        } ./main.py;
      });
}
