SHELL           := /bin/bash
DEFAULT_GOAL    := convert
RELEASE_VERSION := $(shell git describe --tags --abbrev=0)

install-deps:
	@echo "Installing dependencies..."
	rm -rf output
	mkdir -p output
	cp resume.md output/resume-$(RELEASE_VERSION).md
	cp resume.css output/resume-$(RELEASE_VERSION).css
	cp resume.css resume-$(RELEASE_VERSION).css
.PHONY: install-deps

convert-to-docx: install-deps
	@echo "Converting to DOCX..."
	pandoc resume.md -f markdown -t docx -c resume-$(RELEASE_VERSION).css -s -o output/resume-$(RELEASE_VERSION).docx
.PHONY: convert-to-docx

convert-to-html: convert-to-docx
	@echo "Converting to HTML..."
	pandoc resume.md --embed-resources --standalone -f markdown -t html -c resume-$(RELEASE_VERSION).css -s -o output/resume-$(RELEASE_VERSION).html
	mkdir -p html
	cp output/resume-$(RELEASE_VERSION).html html/index.html
.PHONY: convert-to-html

convert: convert-to-html
	@echo "Converting to PDF..."
	wkhtmltopdf --enable-local-file-access output/resume-$(RELEASE_VERSION).html output/resume-$(RELEASE_VERSION).pdf
	zip -jr output/resume-$(RELEASE_VERSION).zip output/resume-$(RELEASE_VERSION).*
.PHONY: convert
