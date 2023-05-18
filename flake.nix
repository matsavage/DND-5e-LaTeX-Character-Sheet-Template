{
  description = "Latex DnD 5e character sheet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = {};
    };

    # latex specific
    dnd = {
      url = "github:rpgtex/DND-5e-LaTeX-Template";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    dnd,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      texlive = pkgs.texlive.combine {
        # inherits {{{
        inherit
          (pkgs.texlive)
          scheme-minimal
          # executables:

          latexmk
          xetex
          # packages:

          ## For DND 5e latex template (see: their packages.txt):

          amsfonts
          atbegshi
          babel
          babel-english
          bookman
          cfr-initials
          cm
          colortbl
          contour
          courier
          ec
          enumitem
          environ
          epstopdf-pkg
          etex-pkg
          etoolbox
          fancyhdr
          fontaxes
          fp
          geometry
          gillius
          hang
          initials
          keycommand
          kpfonts
          kvsetkeys
          l3backend
          l3kernel
          l3packages
          latex-fonts
          lettrine
          lm
          ltxcmds
          luacolor
          microtype
          minifp
          ms
          numprint
          oberdiek
          pgf
          psnfss
          ragged2e
          tcolorbox
          titlesec
          tocloft
          tools
          trimspaces
          was
          xcolor
          xkeyval
          xstring
          ## For this project:

          fontspec
          gensymb
          kpfonts-otf
          pdfcol
          pstricks
          tikzfill
          ### Needed for xdv to pdf:

          pst-tools
          xetex-pstricks
          ;

        #}}}
      };

      buildInputs = [
        texlive
        pkgs.ghostscript_headless # needed for the xdv to pdf step
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

