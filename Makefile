# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
MAPZEN = https://github.com/mapzen/mapzen-docs/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/master.tar.gz

# Add local env/bin to PATH
PATH := $(shell pwd)/env/bin:$(PATH)
SHELL := /bin/bash # required for OSX
PYTHONPATH := packages:$(PYTHONPATH)

# Reset entire source directory
clean-src:
	@echo Cleaning out source directory...
	@rm -rf src/*/

# Reset entire build directory
clean-dist:
	@echo Cleaning out build directory...
	@rm -rf dist/*/

get: clean-src get-tangram get-metro-extracts get-valhalla

# Get individual sources docs
get-tangram:
	@curl -L $(TANGRAM) | tar -zxv -C src --strip-components=1 tangram-docs-gh-pages/pages && mv src/pages src/tangram

get-metro-extracts:
	@curl -L $(MAPZEN) | tar -zxv -C src --strip-components=1 mapzen-docs-master/metro-extracts

get-valhalla:
	@curl -L $(VALHALLA) | tar -zxv -C src && mv src/valhalla-docs-master src/valhalla

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

# Build valhalla docs
valhalla:
	@echo Building Valhalla documentation...
	@ln -sf config/valhalla.yml ./mkdocs.yml
	@mkdocs build --clean # Ensure stale files are cleaned

all: clean-dist tangram metro-extracts valhalla
	# Compress all HTML files - controls Jinja whitespace
	@find dist -name \*.html -ls -exec htmlmin --keep-optional-attribute-quotes {} {} \;

# Sets up CSS compile via Sass, watching for changes
css:
	@sass --watch theme/scss:theme/css

# Set virtual environment & install dependencies
env:
	@echo Verifying and installing Python environment and dependencies...
	@test -d env || virtualenv env
	@env/bin/pip install -Ur requirements.txt
	@env/bin/pip install -e packages/mdx_autolink

.PHONY: all css
