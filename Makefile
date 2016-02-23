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

get: get-tangram get-metro-extracts get-vector-tiles get-turn-by-turn get-elevation get-matrix get-search theme/fragments

# Get individual sources docs
get-tangram:
	@rm -rf src/tangram
	@curl -L $(TANGRAM) | tar -zxv -C src --strip-components=1 tangram-docs-gh-pages/pages && mv src/pages src/tangram

get-metro-extracts:
	@rm -rf src/metro-extracts
	@mkdir -p src/metro-extracts
	@curl -L $(EXTRACTS) | tar -zxv -C src/metro-extracts --strip-components=2 metroextractor-cities-master/docs

get-vector-tiles:
	@rm -rf src/vector-tiles
	@mkdir -p src/vector-tiles
	@curl -L $(VECTOR) | tar -zxv -C src/vector-tiles --strip-components=2 --exclude=README.md vector-datasource-0.8.0-alpha2/docs

get-turn-by-turn:
	@rm -rf src/turn-by-turn
	@curl -L $(VALHALLA) | tar -zxv -C src && mv src/valhalla-docs-master src/turn-by-turn

get-elevation:
	@rm -rf src/elevation
	@curl -L $(VALHALLA) | tar -zxv -C src --strip-components=1 valhalla-docs-master/elevation

get-matrix:
	@rm -rf src/matrix
	@curl -L $(VALHALLA) | tar -zxv -C src --strip-components=1 valhalla-docs-master/matrix

get-search:
	@rm -rf src/search
	@curl -L $(SEARCH) | tar -zxv -C src && mv src/pelias-doc-master src/search

# Retrieve style guide
theme/fragments:
	@mkdir -p theme/fragments
	@curl -L '$(STYLEGUIDE)/src/site/fragments/global-nav.html' -o theme/fragments/global-nav.html
	@curl -L '$(STYLEGUIDE)/src/site/fragments/global-footer.html' -o theme/fragments/global-footer.html

# Build test docs
test-docs:
	@echo Building test documentation...
	@ln -sf config/test.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

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
