FINAL_NAME := radio_summary
TEX_COMPILER := pdflatex -interaction=nonstopmode
TMP_FILES_KEYS := -name "*.out" -o -name "*.toc" -o -name "*.aux" 
TMP_FILES_KEYS += -o -name "*.log" -o -name "*.synctex.gz" -o -name "*backup" 
TMP_FILES_KEYS += -o -name "*~" -o -name "*.bak" -o -not -path './final/*' -name "*.pdf"
GS_OPTIMIZER := gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.6 -dPDFSETTINGS=/printer
GS_OPTIMIZER += -dNOPAUSE -dQUIET -dBATCH -dPrinted=false

SRC_IMAGES := $(wildcard ./section*/images/*/*.tex ./style/logo/*.tex)
PDF_IMAGES := $(patsubst %.tex, %.pdf, $(SRC_IMAGES))

build:
	echo "Сompilation images..."
	make images
	echo "Сompilation main pdf file..."
	(cd ./main && $(TEX_COMPILER) main.tex>>tmp0.log)
	(cd ./main && $(TEX_COMPILER) main.tex>>tmp1.log)
	echo "Optimization main pdf file..."
	$(GS_OPTIMIZER) -sOutputFile=$(FINAL_NAME).pdf ./main/main.pdf
	mkdir -p final
	mv $(FINAL_NAME).pdf ./final/$(FINAL_NAME).pdf
	echo "Done!"
images: $(PDF_IMAGES)
	echo "Images are compiled."
%.pdf: %.tex
	$(TEX_COMPILER) -output-directory $(dir $<) $<>>$(dir $<)tmp.log
clean:
	rm -f $$(find -type f $(TMP_FILES_KEYS))
	echo "Cleaned."

.PHONY: build, clean, images
.SILENT:

