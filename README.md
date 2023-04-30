<<<<<<< HEAD
# DND 5e LaTeX Character Sheet Template
=======
# DND 5e LaTeX Character Template
>>>>>>> b354a92... Documentation (#6)

> LaTeX template to typeset Dungeons and Dragons 5th edition character sheets.

## Features

* Character and Spell sheets
* High degree of customisation available
<<<<<<< HEAD
<<<<<<< HEAD
* Works with XeLaTeX locally

<img src=https://github.com/Chery-cake/DND-5e-LaTeX-Character-Sheet-Template/raw/main/bard-druid_character_sheet.png/>
=======
* Works with XeTeX locally or via GitHub actions
=======
* Works with XeTeX or Nix locally or via GitHub actions
>>>>>>> bbdc157... Docs(README): Mention Nix

<img src=https://github.com/matsavage/DND-5e-LaTeX-Character-Template/blob/documentation/fighter_character_sheet.png />
>>>>>>> b354a92... Documentation (#6)


## Usage

### Building a character sheet

It is reccomended to look at pre-existing character sheets in the `characters` directory when using this repository for the first time, each text input area of the character sheet is fillable with functions defined in the template, however it may require some trial and error to have the sheet looking as you intend.

### Compliation

<<<<<<< HEAD
<<<<<<< HEAD
The example or specific character sheets can be compiled using the following `make` commands:

``` console
make example              # Will complile the example "unnamed" character

make character_name.pdf   # Will compile a character by name from the character directory
```

### Customisation

There are a large number of character sheet customisation options available in [`dndtemplate.sty`](https://github.com/matsavage/DND-5e-LaTeX-Character-Sheet-Template/blob/main/dndtemplate.sty) which acts a central location to modify colour and opacity for a number of character sheet elements. There are some commands in `sheet-calculations` that were made to auto calculate the modifiers and proficiencies, and auto complete a few inputs.
=======
If you use this as a template repository, there is a configured [GitHub Action](https://github.com/matsavage/dnd-latex-action) which will compile all `.tex` files in the `characters` directory to PDF sheets in situ. Alternatively it is reccomended to use XeLaTeX and the [DnD 5e LaTeX Template](https://github.com/rpgtex/DND-5e-LaTeX-Template) if compiling locally.
=======
If you use this as a template repository, there is a configured [GitHub Action](https://github.com/matsavage/dnd-latex-action) which will compile all `.tex` files in the `characters` directory to PDF sheets in situ. Alternatively it is recommended to use XeLaTeX and the [DnD 5e LaTeX Template](https://github.com/rpgtex/DND-5e-LaTeX-Template) if compiling locally.

#### Nix
A nix flake is a reproducible way to describe the building process to [nix](https://nixos.org/).
See https://nixos.org/download.html, on how to install nix.
Afterwards running `nix build` in the repository will result in a successful build.

Flakes and Nix-Commands are still experimental, so they must be enabled
as described at https://nixos.wiki/wiki/Flakes#Enable_flakes.

>>>>>>> bbdc157... Docs(README): Mention Nix

### Customisation

There are a large number of character sheet customisation options available in [`character-sheet-settings.tex`](https://github.com/matsavage/DND-5e-LaTeX-Character-Template/blob/documentation/character-sheet-settings.tex) which acts a central location to modify colour and opacity for a number of character sheet elements.
>>>>>>> b354a92... Documentation (#6)

## Dependencies

This package requires LaTeX and the [DnD 5e LaTeX Template](https://github.com/rpgtex/DND-5e-LaTeX-Template). I reccomend using the [instructions](https://github.com/rpgtex/DND-5e-LaTeX-Template/tree/355b9ced1b42324574c2c4e28f9783f29c760a20#dependencies) provided with this package to set up your environment if not using the included GitHub action.

## Credits

<<<<<<< HEAD
* This package was generated from the standard Wizards of the Coast [PDF character sheet](https://media.wizards.com/2016/dnd/downloads/5E_CharacterSheet_Fillable.pdf) template
=======
* This package was generated from the standard Wizards of the Coast [PDF character sheet](https://media.wizards.com/2016/dnd/downloads/5E_CharacterSheet_Fillable.pdf) template
>>>>>>> b354a92... Documentation (#6)
