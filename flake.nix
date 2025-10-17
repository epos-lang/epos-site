{
  description = "Epos lang site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    learn.url = "path:./src";
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
          cp -r assets/* docs/assets
          cp src/code.css docs/code.css
          cp src/code.js docs/code.js
          ${pkgs.tailwindcss}/bin/tailwindcss -i src/style.css -o docs/style.css -m

          find src -type f -name "*.pdf" | while read -r file; do
            filename=$(basename "$file")
            new_filename=$(echo "$filename" | sed 's/^[0-9]\+-\(.*\)/\1/')
            cp "$file" "docs/$new_filename"
          done
          ${pkgs.tailwindcss}/bin/tailwindcss -i src/learn.css -o docs/learn.css -m
          #${learn.packages.${system}.default}/bin/build-docs
          cp src/html/*.html docs/
        '';
      });
}
