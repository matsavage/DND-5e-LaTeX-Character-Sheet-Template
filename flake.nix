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
        inherit
          (pkgs.texlive)
          scheme-minimal
          collection-luatex
          # Executables:

          latexmk
          luatex
          luahbtex
          latex-bin
          # For DND 5e latex template (see: their packages.txt):

          amsfonts
          atbegshi
          babel
          babel-english
          bookman
          bookmark
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
          hyperref
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
          # For this project:

          fontspec
          gensymb
          kpfonts-otf
          pdfcol
          pstricks
          tikzfill
          pst-tools
          # Needed for lualatex and transparencies:

          luapstricks
          pdfmanagement-testphase
          ;
      };

      buildInputs = [
        texlive
        # pkgs.ghostscript_headless # needed for the xdv to pdf step
        pkgs.gnused
      ];

      pname = "dnd-char-sheet";
      version = "1.0";
      envVars = {
        FONTCONFIG_FILE = pkgs.makeFontsConf {fontDirectories = [./template/fonts];};
        TEXINPUTS = "${builtins.toString ./.}//:${dnd}//:";
        TTFONTS = "${builtins.toString ./.}//:${dnd}//:";
        TEXMFHOME = ".cache";
        TEXMFVAR = ".cache/texmf-var";
      };

      build_character = (
        directory: file_name: let
          file_name_cleaned = pkgs.lib.removeSuffix ".tex" file_name;

          value_derivation = pkgs.stdenv.mkDerivation (pkgs.lib.recursiveUpdate {
              name = "${directory}-${file_name_cleaned}-${pname}-${version}";
              src = ./.;

              inherit buildInputs;

              buildPhase = ''
                latexmk -interaction=nonstopmode -pdf -lualatex ${directory}/${file_name}
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
      );

      build_from_directory = (directory: let
        tex_paths = pkgs.lib.filterAttrs (key: value: value == "regular") (builtins.readDir ./${directory});
        tex_files = pkgs.lib.mapAttrs' (name: _: build_character directory name) tex_paths;
        all_tex_files = pkgs.symlinkJoin {
          name = "${directory}-all";
          paths = pkgs.lib.attrValues tex_files;
        };
      in {
        individual = tex_files;
        combined = all_tex_files;
      });


    in rec {
      packages =
        pkgs.lib.recursiveUpdate {
          default = (build_from_directory "characters").combined;
          test = (build_from_directory "tests").combined;
        }
        (build_from_directory "characters").individual;

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
