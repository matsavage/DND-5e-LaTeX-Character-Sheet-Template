.PHONY: example clean

example: unnamed.pdf

clean:
	rm *.pdf

%.pdf: characters/%.tex
	CHARACTERNAME=$(basename $< |  sed 's:.*/::')
	rm -rdf CHARACTERNAME
	mkdir CHARACTERNAME
	xelatex $<

nix_build:
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes
