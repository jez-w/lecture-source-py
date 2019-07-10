# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = python -msphinx
SPHINXPROJ    = lecture-source-jl
SOURCEDIR     = source/rst
BUILDDIR      = _build
CORES 		  = 4
BUILDCOVERAGE = _build_coverage
BUILDPDF      = _build_pdf

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Install requiremenets for building lectures.
setup:
	pip install -r requirements.txt
	
local:
	@$(SPHINXBUILD) -M jupyter "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O) -D jupyter_images_urlpath=0 -D jupyter_images_markdown=1

notebooks:
	make jupyter

preview-nb:
ifdef lecture
	cd _build/jupyter/ && jupyter notebook $(basename $(lecture)).ipynb
else
	cd _build/jupyter/ && jupyter notebook
endif

preview:
	cd _build/jupyter_html/ && python -m http.server

clean-coverage:
	rm -rf $(BUILDCOVERAGE)

coverage: clean-coverage
	@$(SPHINXBUILD) -M jupyter "$(SOURCEDIR)" "$(BUILDCOVERAGE)" $(SPHINXOPTS) $(O) -D jupyter_make_coverage=1 -D jupyter_make_site=0 -D jupyter_generate_html=0 -D jupyter_ignore_skip_test=0 -D jupyter_download_nb=0 

coverage-parallel: clean-coverage
	@$(SPHINXBUILD) -M jupyter "$(SOURCEDIR)" "$(BUILDCOVERAGE)" $(SPHINXOPTS) $(O) -D jupyter_make_coverage=1 -D jupyter_make_site=0 -D jupyter_generate_html=0 -D jupyter_ignore_skip_test=0 -D jupyter_download_nb=0 -D jupyter_number_workers=$(CORES)

jupyter-parallel:
	@$(SPHINXBUILD) -M jupyter "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O) -D jupyter_number_workers=$(CORES)

jupyterpdf:
	@$(SPHINXBUILD) -M jupyterpdf "$(SOURCEDIR)" "$(BUILDPDF)" $(SPHINXOPTS) $(O) -D jupyter_number_workers=$(CORES)

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)