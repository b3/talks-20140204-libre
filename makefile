LATEX =	pdflatex -jobname $(basename $@) '$(LATEXCMDS)\input{$(basename $<)}'

define RUN_LATEX
export TEXINPUTS=.//:
export BIBINPUTS=.//:
export BSTINPUTS=.//:
$(LATEX) && \
if grep -qE '\.bib' $< ; then bibtex $(basename $< .tex) ; fi && \
$(LATEX) && $(LATEX)
endef

sinclude makefile.ext

%.pdf: %.svg
	inkscape -z -d 2400 -A $@ -T $<

%.pdf: %.fig
	fig2dev -L pdf $< $@

%.pdf: %.ps
	ps2pdf $< $@

%.pdf: %.tex
	$(RUN_LATEX)

.PHONY: zip
zip: dir = $(notdir $(PWD))
zip: clean
	-cd .. ; rm $(dir).zip ; zip -r $(dir).zip $(dir)

.PHONY: clean
clean:
	-rm -f *~ *.aux *.bbl *.blg *.toc *.lof *.log *.lot *.flg *.out *.nav *.snm *.bak *.vrb $(CLEAN_FILES)

.PHONY: dist-clean
dist-clean:
	$(MAKE) clean
	-rm -f *.pdf $(DIST-CLEAN_FILES)
