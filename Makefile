PDF_FLAGS = --fontsize 9.0 \
			--linkstyle plain \
			--linkcolor green \
			--embedfonts \
			--footer "c 1" \
			--no-toc

MD = pages/index.md \
      	 chapters/Table_Of_Contents.md \
      	 chapters/Deploying_Applications.md \
      	 chapters/Setting_Up_Databases.md \
      	 chapters/Using_The_Jitsu_Client.md \
      	 chapters/Using_The_API.md \
      	 chapters/The_Marketplace.md \
      	 chapters/Add_Ons.md \
      	 chapters/Open_Source_Projects.md

HTML = $(MD:.md=.html)

all: book.html book.pdf book.mobi book.epub

regenerate: clean all
	git commit -a -m 'Regenerated book' && echo done

book.pdf: $(HTML)
	@echo "\n... generating $@"
	htmldoc $(HTML) $(PDF_FLAGS) --outfile $@

book.html: pages/head.html pages/tail.html $(HTML)
	@echo "\n... generating $@"
	@echo $(HTML)
	cat pages/head.html $(HTML) pages/tail.html > book.html

%.html: %.md
	ronn --pipe --fragment $< \
		| sed -E 's/<h1>([^ ]+) - /<h1>/' \
		> $@

book.mobi:
	@echo "\n... generating $@"
	ebook-convert book.html book.mobi --output-profile kindle

book.epub:
	@echo "\n... generating $@"
	ebook-convert book.html book.epub \
		--title "Mastering Node" \
		--no-default-epub-cover \
		--authors "TJ Holowaychuk" \
		--language en \
		--cover pages/cover.jpg

view: book.pdf
	open book.pdf

clean:
	rm -f book.*
	rm -f chapters/*.html

.PHONY: view clean regenerate