{
  description = "Phase Field Method Recommended Practices";

  inputs = {
    # NOTE: Using 26.05 to support intel macs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            pkg-config

            # Main packages
            python313
            python313Packages.jupyter-book
          ];

          shellHook = ''
            alias pf_build="jupyter book build"
            alias pf_serve="jupyter book start"
            alias pf_clean="jupyter book clean -y"

            pf_help() {
              echo "Available development commands:"
              echo "  pf_build    Build docs"
              echo "  pf_serve    Serve docs at http://localhost:3000"
              echo "  pf_clean    Clean docs build"
              echo ""
              echo "Run pf_help to display this list again."
            }
            echo "Dev shell loaded!"
            pf_help
          '';
        };
      };
    };
}
