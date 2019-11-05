# Get the version info for later
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)

all: docs check clean

docs:
	R -q -e 'library("roxygen2"); roxygenise(".")'

build: docs
	cd ..;\
	R CMD build canadaHCD

check: build
	cd ..;\
	export NOT_CRAN="true"; \
	echo "$${NOT_CRAN}"; \
	R CMD check canadaHCD_$(PKGVERS).tar.gz

check-cran: build
	cd ..;\
	R CMD check --as-cran canadaHCD_$(PKGVERS).tar.gz

install: build
	cd ..;\
	R CMD INSTALL canadaHCD_$(PKGVERS).tar.gz

move: check
	cp ../canadaHCD.Rcheck/canadaHCD-Ex.Rout ./tests/Examples/canadaHCD-Ex.Rout.save

clean:
	cd ..;\
	rm -r canadaHCD.Rcheck/

purl:
	cd ..;\
	R -q -e 'library("knitr"); purl("./canadaHCD/vignettes/canadaHCD.Rnw")'

knit:
	R -q -e 'library("knitr"); knit("./README.Rmd")'
