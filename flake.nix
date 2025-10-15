{
  description = "Epos lang site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.writeShellScriptBin "build" ''
          rm -rf docs
          mkdir docs docs/assets
          cp src/index.html docs/index.html
          cp -r public/assets/* docs/assets
          ${pkgs.tailwindcss}/bin/tailwindcss -i src/style.css -o docs/style.css -m
        '';
      });
}
