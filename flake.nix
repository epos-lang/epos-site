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
        packages.default = pkgs.stdenv.mkDerivation {
          name = "epos-site";
          src = self;
          buildInputs = with pkgs; [
            tailwindcss
            inotify-tools
            static-web-server
          ];
          nativeBuildInputs = with pkgs; [ makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin
            cat > $out/bin/serve <<EOF
              #!/usr/bin/env ${pkgs.bash}/bin/bash

              function run_on_change {
                ${pkgs.inotify-tools}/bin/inotifywait -e modify -e move -e create -e delete -r src/. | while read -r directory events file; do
                  cp src/index.html docs/index.html
                  #rm docs/assets/*
                  #cp src/assets/* docs/assets/
                  ${pkgs.tailwindcss}/bin/tailwindcss -i src/style.css -o docs/style.css -m &
                done
              }
              run_on_change &

              ${pkgs.static-web-server}/bin/static-web-server -p 8081 -d docs/.
            EOF
            chmod +x $out/bin/serve
            wrapProgram $out/bin/serve \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  pkgs.tailwindcss
                  pkgs.inotify-tools
                  pkgs.static-web-server
                ]
              }
          '';
        };

        devShells.default = pkgs.mkShell {
          #packages = with pkgs; [ static-web-server ];
          shellHook = ''
            echo "Run './result/bin/serve'"
          '';
        };
      });
}
