.PHONY: example clean

example: unnamed.pdf

clean:
	rm *.pdf

%.pdf: characters/%.tex
	CHARACTERNAME=$(basename $< |  sed 's:.*/::')
	rm -rdf CHARACTERNAME
	mkdir CHARACTERNAME
	xelatex $<
