# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
EXTRACTS = https://github.com/mapzen/metroextractor-cities/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/master.tar.gz
VECTOR = https://github.com/mapzen/vector-datasource/archive/v0.8.0-alpha2.tar.gz
SEARCH = https://github.com/pelias/pelias-doc/archive/master.tar.gz

# Mapzen styleguide
STYLEGUIDE = https://github.com/mapzen/styleguide/raw/master

# Add local env/bin to PATH
PATH := $(shell pwd)/env/bin:$(PATH)
SHELL := /bin/bash # required for OSX
PYTHONPATH := packages:$(PYTHONPATH)

# Reset entire build directory
clean-dist:
	@echo Cleaning out build directory...
	@rm -rf dist/*/
	@mkdir -p src

get: src-tangram src-metro-extracts src-vector-tiles src-turn-by-turn src-elevation src-matrix src-search theme/fragments
	mkdir -p src
	rm -f src/tangram && ln -s ../src-tangram src/tangram
	rm -f src/metro-extracts && ln -s ../src-metro-extracts src/metro-extracts
	rm -f src/vector-tiles && ln -s ../src-vector-tiles src/vector-tiles
	rm -f src/turn-by-turn && ln -s ../src-turn-by-turn src/turn-by-turn
	rm -f src/elevation && ln -s ../src-elevation src/elevation
	rm -f src/matrix && ln -s ../src-matrix src/matrix
	rm -f src/search && ln -s ../src-search src/search

# Get individual sources docs
src-tangram:
	mkdir src-tangram
	curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-gh-pages/pages

src-metro-extracts:
	mkdir src-metro-extracts
	curl -sL $(EXTRACTS) | tar -zxv -C src-metro-extracts --strip-components=2 metroextractor-cities-master/docs

src-vector-tiles:
	mkdir src-vector-tiles
	curl -sL $(VECTOR) | tar -zxv -C src-vector-tiles --strip-components=2 --exclude=README.md vector-datasource-0.8.0-alpha2/docs

src-turn-by-turn:
	mkdir src-turn-by-turn
	curl -sL $(VALHALLA) | tar -zxv -C src-turn-by-turn --strip-components=1 valhalla-docs-master

src-elevation:
	mkdir src-elevation
	curl -sL $(VALHALLA) | tar -zxv -C src-elevation --strip-components=2 valhalla-docs-master/elevation

src-matrix:
	mkdir src-matrix
	curl -sL $(VALHALLA) | tar -zxv -C src-matrix --strip-components=2 valhalla-docs-master/matrix

src-search:
	mkdir src-search
	curl -sL $(SEARCH) | tar -zxv -C src-search --strip-components=1 pelias-doc-master

# Retrieve style guide
theme/fragments:
	@mkdir -p theme/fragments
	@curl -L '$(STYLEGUIDE)/src/site/fragments/global-nav.html' -o theme/fragments/global-nav.html
	@curl -L '$(STYLEGUIDE)/src/site/fragments/global-footer.html' -o theme/fragments/global-footer.html

# Build tangram docs
tangram:
	@echo Building Tangram documentation...
	@anyconfig_cli ./config/default.yml ./config/tangram.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build metro-extracts docs
metro-extracts:
	@echo Building Metro Extracts documentation...
	@anyconfig_cli ./config/default.yml ./config/metro-extracts.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build vector-tiles docs
vector-tiles:
	@echo Building Vector Tiles documentation...
	@anyconfig_cli ./config/default.yml ./config/vector-tiles.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build turn-by-turn docs
turn-by-turn:
	@echo Building Turn-by-Turn documentation...
	@anyconfig_cli ./config/default.yml ./config/turn-by-turn.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build elevation service docs
elevation:
	@echo Building Elevation Service documentation...
	@anyconfig_cli ./config/default.yml ./config/elevation.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build time-distance matrix service docs
matrix:
	@echo Building Time-Distance Matrix Service documentation...
	@anyconfig_cli ./config/default.yml ./config/matrix.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build Search/Pelias docs
search:
	@echo Building Search [Pelias] documentation...
	@anyconfig_cli ./config/default.yml ./config/search.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

all: clean-dist tangram metro-extracts vector-tiles turn-by-turn search elevation matrix
	# Compress all HTML files - controls Jinja whitespace
	@find dist -name \*.html -ls -exec htmlmin --keep-optional-attribute-quotes {} {} \;

# Set virtual environment & install dependencies
env:
	@echo Verifying and installing Python environment and dependencies...
	@test -d env || virtualenv -p python3 env
	@env/bin/pip install -Ur requirements.txt
	@env/bin/pip install https://github.com/facelessuser/pymdown-extensions/archive/master.zip
	@npm install

serve:
	@mkdocs serve

.PHONY: all env serve
