# Source doc tarballs
#TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
MAPZEN = https://github.com/mapzen/mapzen-docs/archive/master.tar.gz
#VALHALLA = https://github.com/valhalla/valhalla-docs/archive/master.tar.gz
VECTOR = https://github.com/mapzen/vector-tile-service-docs/archive/master.tar.gz
SEARCH = https://github.com/pelias/pelias-doc/archive/master.tar.gz

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
	@curl -L $(VECTOR) | tar -zxv -C src && mv src/vector-tile-service-docs-master src/vector-tiles

get-turn-by-turn:
	@rm -rf src/turn-by-turn
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/turn-by-turn

get-elevation:
	@rm -rf src/elevation
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/elevation

get-search:
	@rm -rf src/search
	@curl -L $(SEARCH) | tar -zxv -C src && mv src/pelias-doc-master src/search

# Build test docs
test-docs: css-once
	@echo Building test documentation...
	@ln -sf config/test.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build tangram docs
tangram: css-once
	@echo Building Tangram documentation...
	@anyconfig_cli ./config/default.yml ./config/tangram.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build metro-extracts docs
metro-extracts: css-once
	@echo Building Metro Extracts documentation...
	@anyconfig_cli ./config/default.yml ./config/metro-extracts.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build vector-tiles docs
vector-tiles: css-once
	@echo Building Vector Tiles documentation...
	@anyconfig_cli ./config/default.yml ./config/vector-tiles.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build turn-by-turn docs
turn-by-turn: css-once
	@echo Building Turn-by-Turn documentation...
	@anyconfig_cli ./config/default.yml ./config/turn-by-turn.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build elevation service docs
elevation: css-once
	@echo Building Elevation Service documentation...
	@anyconfig_cli ./config/default.yml ./config/elevation.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

# Build Search/Pelias docs
search: css-once
	@echo Building Search [Pelias] documentation...
	@anyconfig_cli ./config/default.yml ./config/search.yml --merge=merge_dicts --output=./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

all: clean-dist tangram metro-extracts vector-tiles turn-by-turn search elevation
	# Compress all HTML files - controls Jinja whitespace
	@find dist -name \*.html -ls -exec htmlmin --keep-optional-attribute-quotes {} {} \;

# Sets up CSS compile via Sass, watching for changes
css:
	@sassc --sourcemap --watch theme/scss/base.scss theme/css/base.css

# Sets up CSS compile via Sass, no watch
css-once:
	@sassc --sourcemap theme/scss/base.scss theme/css/base.css

# Set virtual environment & install dependencies
env:
	@echo Verifying and installing Python environment and dependencies...
	@test -d env || virtualenv -p python3 env
	@env/bin/pip install -Ur requirements.txt
	@env/bin/pip install https://github.com/facelessuser/pymdown-extensions/archive/master.zip
	@npm install

serve:
	@mkdocs serve

.PHONY: all css env serve
