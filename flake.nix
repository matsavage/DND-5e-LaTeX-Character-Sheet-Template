{
  description = "Latex DnD 5e character sheet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
nixpkgs_old.url = "github:NixOS/nixpkgs/release-22.11";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = {};
    };

    dnd = {
      url = "github:rpgtex/DND-5e-LaTeX-Template";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs_old,
    flake-utils,
    dnd,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs_old = nixpkgs_old.legacyPackages.${system};

      buildInputs = [
        pkgs_old.texlive.combined.scheme-full # use as rungs has been removed
        pkgs.gnused
      ];
      pname = "dnd-char-sheet";
      version = "1.0";
      envVars = {
        FONTCONFIG_FILE = pkgs.makeFontsConf {fontDirectories = [./template/fonts];};
        TEXINPUTS = "${builtins.toString ./.}//:${dnd}//:";
      };
    in {
      packages.default = pkgs.stdenv.mkDerivation (pkgs.lib.recursiveUpdate {
          name = "${pname}-${version}";

          src = ./.;

          inherit buildInputs;

          patchPhase = ''
            sed -i '2s|Path=template/fonts/,Extension=.ttf,||' dndtemplate.sty

            # the following input should be safe, as nix builds things in a sandbox.
            cat << EOF > latexmkrc
            \$xdvipdfmx = 'xdvipdfmx -E -o %D -D "rungs -q -dALLOWPSTRANSPARENCY -dNOSAFER -dNOPAUSE -dBATCH -dEPSCrop -sPAPERSIZE=a0 -sDEVICE=pdfwrite -dCompatibilityLevel=%v -dAutoFilterGrayImages=false -dGrayImageFilter=/FlateEncode -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -dAutoRotatePages=/None -sOutputFile=\\'%o\\' \\'%i\\' -c quit" %O %S';
            EOF
          '';

          buildPhase = ''
            latexmk -file-line-error -xelatex -outdir=build characters/unnamed/sheet.tex
          '';

          installPhase = ''
            mkdir --parents $out/logs
            cp build/*.log $out/logs
            cp build/*.pdf $out
          '';
        }
        envVars);
      devShells.default = pkgs.mkShell (pkgs.lib.recursiveUpdate {
          packages = with pkgs; [
            nil
            alejandra
            statix
            ltex-ls

            texlab
            zathura
          ];
          inherit buildInputs;
        }
        envVars);
    });
}
# vim: ts=2

