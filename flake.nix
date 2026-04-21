{
  description = "A flake for running a python script with uv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        test_grammar = pkgs.writeShellScriptBin "run test" ''
          cat mlir.sublime-syntax > "$(${pkgs.bat} --config-dir)/syntaxes/mlir.sublime-syntax"
          bat cache --build
          cat sample.mlir | bat -lmlir
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
          program = test_grammar;
        };
      }
    );
}