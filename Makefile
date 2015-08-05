# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
MAPZEN = https://github.com/mapzen/mapzen-docs/archive/master.tar.gz
VALHALLA_DEMOS = https://github.com/valhalla/demos/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/gh-pages.tar.gz

# Reset entire source directory
clean-src:
	rm -rf ./src/
	mkdir src
	touch ./src/.gitkeep

# Reset entire build directory
clean-build:
	rm -rf ./build/
	mkdir build
	touch ./build/.gitkeep

get: clean-src get-tangram get-metro-extracts get-valhalla-demos get-valhalla

# Get individual sources docs
get-tangram:
	curl -L $(TANGRAM) | tar -zxvf - -C src --strip-components=1 tangram-docs-gh-pages/pages && mv src/pages src/tangram

get-metro-extracts:
	curl -L $(MAPZEN) | tar -zxvf - -C src --strip-components=1 mapzen-docs-master/metro-extracts

get-valhalla-demos:
	curl -L $(VALHALLA_DEMOS) | tar -zxvf - -C src --strip-components=1 demos-master/docs && mv src/docs src/valhalla-demos

get-valhalla:
	curl -L $(VALHALLA) | tar -zxv - -C src && mv src/valhalla-docs-gh-pages src/valhalla

# Build and serve tangram docs
tangram: virtualenv
	ln -sf config/tangram.yml ./mkdocs.yml
	env/bin/mkdocs build

# Build and serve metro-extracts docs
metro-extracts: virtualenv
	ln -sf config/metro-extracts.yml ./mkdocs.yml
	env/bin/mkdocs build

# Build and serve valhalla-demos docs
valhalla-demos: virtualenv
	ln -sf config/valhalla-demos.yml ./mkdocs.yml
	env/bin/mkdocs build

# Build and serve valhalla docs
valhalla: virtualenv
	ln -sf config/valhalla.yml ./mkdocs.yml
	env/bin/mkdocs build

all: clean-build tangram metro-extracts valhalla-demos valhalla

# Set virtual environment & install dependencies
virtualenv:
	test -d env || virtualenv env
	env/bin/pip install -Ur requirements.txt

.PHONY: tangram
