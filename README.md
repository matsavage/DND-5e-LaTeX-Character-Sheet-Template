# DND 5e LaTeX Character Sheet Template

> LaTeX template to typeset Dungeons and Dragons 5th edition character sheets.

[![Test LaTeX Template](https://github.com/matsavage/DND-5e-LaTeX-Character-Sheet-Template/actions/workflows/test_latex_template.yml/badge.svg?branch=main)](https://github.com/matsavage/DND-5e-LaTeX-Character-Sheet-Template/actions/workflows/test_latex_template.yml)

## Features

* Character and Spell sheets
* High degree of customisation available
* Simplified build with Nix

<img src=https://github.com/matsavage/DND-5e-LaTeX-Character-Sheet-Template/raw/main/aaliyah.png/>

## Usage

### Building a character sheet

It is reccomended to look at pre-existing character sheets in the `characters` directory when using this repository for the first time, each text input area of the character sheet is fillable with functions defined in the template, however it may require some trial and error to have the sheet looking as you intend.

## Compliation

### Nix
A nix flake is a reproducible way to describe the building process to [nix](https://nixos.org/).
See https://nixos.org/download.html, on how to install nix.
Afterwards running `nix build` in the repository will result in a successful build.

Flakes and Nix-Commands are still experimental, so they must be enabled
as described at https://nixos.wiki/wiki/Flakes#Enable_flakes.

### Makefile
The example or specific character sheets can be compiled using the following `make` commands:

``` console
name build                               # Will complile all characters

make build_character CHARACTER=unnamed   # Will complile the example "unnamed" character

make develop                             # Will drop you into a shell with all dependencies installed
```

### Overleaf

This package can be used as-is with Overleaf, however this does not support the DnD 5e template, so will render with a plain white background.

Steps for running on Overleaf:
* Download repository as a .zip file from the `Code <>` menu in GitHub
* Create a new project in Overleaf from a zip upload
* Change the root document to `characters/aaliyah-plain.tex` and the engine to `LuaLaTeX`

The document should then compile normally.

### Customisation

There are a large number of character sheet customisation options available in [`dndtemplate.sty`](https://github.com/matsavage/DND-5e-LaTeX-Character-Sheet-Template/blob/main/dndtemplate.sty) which acts a central location to modify colour and opacity for a number of character sheet elements. There are some commands in `sheet-calculations` that were made to auto calculate the modifiers and proficiencies, and auto complete a few inputs.

## Dependencies

This package requires LaTeX and the [DnD 5e LaTeX Template](https://github.com/rpgtex/DND-5e-LaTeX-Template). I reccomend using the [instructions](https://github.com/rpgtex/DND-5e-LaTeX-Template/tree/355b9ced1b42324574c2c4e28f9783f29c760a20#dependencies) provided with this package to set up your environment if not using the included GitHub action.

## Credits

* This package was generated from the standard Wizards of the Coast [PDF character sheet](https://media.wizards.com/2016/dnd/downloads/5E_CharacterSheet_Fillable.pdf) template
