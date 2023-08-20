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
      static_packages = pkgs.lib.filterAttrs (key: value: pkgs.lib.isDerivation value) (
        pkgs.lib.attrsets.mapAttrs' (
          file_name: state:
            if state == "regular"
            then let
              file_name_cleaned = pkgs.lib.removeSuffix ".tex" file_name;
              value_derivation = pkgs.stdenv.mkDerivation (pkgs.lib.recursiveUpdate {
                  name = "${file_name}-${pname}-${version}";

                  src = ./.;

                  inherit buildInputs;

                  patchPhase = ''
                    sed -i '9s|Path=template/fonts/,Extension=.ttf,||' dndtemplate.sty

                    # -dNOSAFER is safe in this context, as nix builds things in a sandbox
                    cat << EOF > latexmkrc
                    \$xdvipdfmx = 'xdvipdfmx -E -o %D -D "gs -q -dALLOWPSTRANSPARENCY -dNOSAFER -dNOPAUSE -dBATCH -dEPSCrop -sPAPERSIZE=a0 -sDEVICE=pdfwrite -dCompatibilityLevel=%v -dAutoFilterGrayImages=false -dGrayImageFilter=/FlateEncode -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -dAutoRotatePages=/None -sOutputFile=\\'%o\\' \\'%i\\' -c quit" %O %S';
                    EOF
                  '';

                  buildPhase = ''
                    latexmk -file-line-error -xelatex characters/*
                  '';

                  installPhase = ''
                    mkdir --parents $out/logs
                    cp ./*.log $out/logs
                    cp ${file_name_cleaned}.pdf $out
                  '';
                }
                envVars);
            in
              pkgs.lib.nameValuePair file_name_cleaned value_derivation
            else pkgs.lib.nameValuePair "${file_name}.directory" state
        ) (builtins.readDir ./characters)
      );
      default_package = static_packages."${builtins.head (builtins.attrNames static_packages)}";
    in {
      packages =
        pkgs.lib.recursiveUpdate {
          default = default_package;
        }
        static_packages;
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
