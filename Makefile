# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/reorg.tar.gz
MAPZEN = https://github.com/mapzen/mapzen-docs/archive/master.tar.gz
VALHALLA_DEMOS = https://github.com/valhalla/demos/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/gh-pages.tar.gz

# Reset entire source directory
clean-src:
	@echo Cleaning out source directory...
	@rm -rf src/*/

# Reset entire build directory
clean-build:
	@echo Cleaning out build directory...
	@rm -rf build/*/

get: clean-src get-tangram get-metro-extracts get-valhalla-demos get-valhalla

# Get individual sources docs
get-tangram:
	@curl -L $(TANGRAM) | tar -zxvf - -C src --strip-components=1 tangram-docs-reorg/pages && mv src/pages src/tangram

get-metro-extracts:
	@curl -L $(MAPZEN) | tar -zxvf - -C src --strip-components=1 mapzen-docs-master/metro-extracts

get-valhalla-demos:
	@curl -L $(VALHALLA_DEMOS) | tar -zxvf - -C src --strip-components=1 demos-master/docs && mv src/docs src/valhalla-demos

get-valhalla:
	@curl -L $(VALHALLA) | tar -zxv - -C src && mv src/valhalla-docs-gh-pages src/valhalla

# Build tangram docs
tangram: virtualenv
	@echo Building Tangram documentation...
	@ln -sf config/tangram.yml ./mkdocs.yml
	@env/bin/mkdocs build

# Build metro-extracts docs
metro-extracts: virtualenv
	@echo Building Metro Extracts documentation...
	@ln -sf config/metro-extracts.yml ./mkdocs.yml
	@env/bin/mkdocs build

# Build valhalla-demos docs
valhalla-demos: virtualenv
	@echo Building Valhalla/demos documentation...
	@ln -sf config/valhalla-demos.yml ./mkdocs.yml
	@env/bin/mkdocs build

# Build valhalla docs
valhalla: virtualenv
	@echo Building Valhalla documentation...
	@ln -sf config/valhalla.yml ./mkdocs.yml
	@env/bin/mkdocs build

all: clean-build tangram metro-extracts valhalla-demos valhalla

# Set virtual environment & install dependencies
virtualenv:
	@echo Verifying and installing Python environment and dependencies...
	@test -d env || virtualenv env
	@env/bin/pip install -Ur requirements.txt

.PHONY: tangram
