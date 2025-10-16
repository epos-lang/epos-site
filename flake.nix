{
  description = "Epos lang site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    learn.url = "path:./src/learn";
  };

  outputs = { self, nixpkgs, flake-utils, learn }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.writeShellScriptBin "build" ''
          rm -rf docs
          mkdir docs docs/assets docs/learn
          echo "epos-lang.org" > docs/CNAME
          cp src/index.html docs/index.html
          cp -r public/assets/* docs/assets

          cp src/learn/*.pdf docs/learn/
          ${learn.packages.${system}.default}/bin/build-docs
          cp src/learn/html/*.html docs/learn/

          ${pkgs.tailwindcss}/bin/tailwindcss -i src/style.css -o docs/style.css -m
        '';
      });
}
