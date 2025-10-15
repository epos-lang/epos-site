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
        packages.default = pkgs.writeShellScriptBin "serve" ''
          function run {
            cp src/index.html docs/index.html
            rm -rf docs/assets/*
            cp -r src/assets/* docs/assets/
            ${pkgs.tailwindcss}/bin/tailwindcss -i src/style.css -o docs/style.css -m &
          }
          run
          function run_on_change {
            ${pkgs.inotify-tools}/bin/inotifywait -e modify -e move -e create -e delete -r src/. | while read -r directory events file; do
              run
            done
          }
          run_on_change &

          #${pkgs.static-web-server}/bin/static-web-server -p 8084 -d docs/.
        '';

        devShells.default = pkgs.mkShell {
          #packages = with pkgs; [ static-web-server ];
          shellHook = ''
            echo "Run './result/bin/serve'"
          '';
        };
      });
}
