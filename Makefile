# Source doc tarballs
#TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
MAPZEN = https://github.com/mapzen/mapzen-docs/archive/master.tar.gz
#VALHALLA = https://github.com/valhalla/valhalla-docs/archive/master.tar.gz
#SEARCH = https://github.com/pelias/pelias-doc/archive/master.tar.gz

# Add local env/bin to PATH
PATH := $(shell pwd)/env/bin:$(PATH)
SHELL := /bin/bash # required for OSX
PYTHONPATH := packages:$(PYTHONPATH)

# Reset entire build directory
clean-dist:
	@echo Cleaning out build directory...
	@rm -rf dist/*/

get: get-tangram get-metro-extracts get-vector-tiles get-turn-by-turn get-elevation get-search

# Get individual sources docs
get-tangram:
	@rm -rf src/tangram
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/tangram

get-metro-extracts:
	@rm -rf src/metro-extracts
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/metro-extracts

get-vector-tiles:
	@rm -rf src/vector-tiles
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/vector-tiles

get-turn-by-turn:
	@rm -rf src/turn-by-turn
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/turn-by-turn

get-elevation:
	@rm -rf src/elevation
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/elevation

get-search:
	@rm -rf src/search
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/search

# Build test docs
test-docs:
	@echo Building test documentation...
	@ln -sf config/test.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build tangram docs
tangram:
	@echo Building Tangram documentation...
	@ln -sf config/tangram.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build metro-extracts docs
metro-extracts:
	@echo Building Metro Extracts documentation...
	@ln -sf config/metro-extracts.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build vector-tiles docs
vector-tiles:
	@echo Building Vector Tiles documentation...
	@ln -sf config/vector-tiles.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build turn-by-turn docs
turn-by-turn:
	@echo Building Turn-by-Turn documentation...
	@ln -sf config/turn-by-turn.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build elevation service docs
elevation:
	@echo Building Elevation Service documentation...
	@ln -sf config/elevation.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build Search/Pelias docs
search:
	@echo Building Search [Pelias] documentation...
	@ln -sf config/search.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

all: clean-dist tangram metro-extracts vector-tiles turn-by-turn search elevation
	# Compress all HTML files - controls Jinja whitespace
	@find dist -name \*.html -ls -exec htmlmin --keep-optional-attribute-quotes {} {} \;

# Sets up CSS compile via Sass, watching for changes
css:
	@env/bin/sassc --sourcemap --watch theme/scss/base.scss theme/css/base.css

# Set virtual environment & install dependencies
env:
	@echo Verifying and installing Python environment and dependencies...
	@test -d env || virtualenv -p python3 env
	@env/bin/pip install -Ur requirements.txt
	@env/bin/pip install https://github.com/facelessuser/pymdown-extensions/archive/master.zip
	@npm install
	# @env/bin/pip install -e extensions/mdx_autolink

serve:
	@env/bin/mkdocs serve

.PHONY: all css env serve
