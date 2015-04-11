ideal_draft.pdf: ideal_draft.md
	pandoc -H options.sty ideal_draft.md -o ideal_draft.pdf --bibliography=/data/Copy/1-src/lit/Literature.bib --variable fontsize=12pt

ideal_draft.docx: ideal_draft.md
	pandoc ideal_draft.md -o ideal_draft.docx --bibliography=/data/Copy/1-src/lit/Literature.bib --number-sections --csl=ajps.csl
