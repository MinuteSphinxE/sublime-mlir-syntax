{
  description = "mlir test";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        test_grammar = pkgs.writeShellScriptBin "run-test" ''
          export PATH="${pkgs.coreutils}/bin:${pkgs.bat}/bin:$PATH"
          CONF_DIR=$(${pkgs.bat}/bin/bat --config-dir)
          echo "Creating config directory at $CONF_DIR"
          mkdir -p "$CONF_DIR/syntaxes"
          cp ${./mlir.sublime-syntax} "$CONF_DIR/syntaxes/mlir.sublime-syntax"
          bat cache --build
          if [ -f "sample.mlir" ]; then
            cat sample.mlir | bat -l mlir
          else
            echo "Error: sample.mlir not found."
          fi
'';
      in
      {

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bat
          ];
        };

        apps.default = {
          type = "app";
          program = "${test_grammar}/bin/run-test";
        };
      }
    );
}