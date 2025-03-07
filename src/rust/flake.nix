{
  description = "";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.rust = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ rust.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };

        toolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        # required for rustfmt nightly options
        rustfmt-nightly = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.rustfmt);

        buildInputs = with pkgs; [
        ];

        nativeBuildInputs = with pkgs; [
          toolchain
        ];
      in
      {
        devShell = pkgs.mkShell {
          inherit buildInputs;
          nativeBuildInputs = nativeBuildInputs ++ [
            rustfmt-nightly
          ];
        };
      }
    );
  }

