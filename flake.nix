{
  description = "A command line utility for batch renaming files in an editor";

  inputs = {
    nixpkgs.url = "nixpkgs";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    naersk = {
      url = "github:nix-community/naersk/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, naersk }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
      in
      {
        packages.default = naersk-lib.buildPackage {
          src = ./.;
          buildInputs = [ pkgs.glibc ];
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cargo rustc rustfmt pre-commit clippy rust-analyzer ];
          RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
        };
      });
}
