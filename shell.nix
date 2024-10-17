{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let 
  system = builtins.currentSystem;
  extensions =
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nix-vscode-extensions";
      ref = "refs/heads/master";
      rev = "c43d9089df96cf8aca157762ed0e2ddca9fcd71e";
    })).extensions.${system};
  extensionsList = with extensions.vscode-marketplace; [
    vscodevim.vim
    donjayamanne.git-extension-pack
    eamodio.gitlens
    vadimcn.vscode-lldb
    rust-lang.rust-analyzer
    # 1YiB.rust-bundle
  ];
in pkgs.mkShell {
  buildInputs = [
    # pkgs.gnumake
    pkgs.cargo
    pkgs.rustc
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = extensionsList;
    })
  ];

  # shellHook = ''
  #   # execute some bash during hook time
  # '';
}

