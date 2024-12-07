{
  description = "rust dev flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = "${system}";
      config.allowUnfree = true;
      overlays = [ rust-overlay.overlays.default ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell{
      nativeBuildInputs = [
	# pkgs.rust-bin.nightly."2023-04-30".default
        pkgs.lldb
        pkgs.rust-analyzer
        pkgs.cargo
        pkgs.rustup
        pkgs.jetbrains.rust-rover
        ## HELIX
        # pkgs.helix
        # pkgs.helix-gpt
      ];
      shellHook = ''
	rustup toolchain install 1.80.0
        rustup default 1.80.0
	rustup component add rust-src
        echo "Welcome to htb bot"
      '';
    };
  };

}
