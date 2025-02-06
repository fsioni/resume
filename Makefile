.PHONY: all clean

CURRENT_DIR := $(shell pwd)

all:
	docker run --rm -v $(CURRENT_DIR):/workdir -w /workdir/resume registry.gitlab.com/islandoftex/images/texlive:latest latexmk -pdf main.tex

clean:
	rm -f resume/*.{aux,log,out,toc,lof,lot,fls,fdb_latexmk,pdf}