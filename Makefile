# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
MAPZEN = https://github.com/mapzen/mapzen-docs/archive/master.tar.gz
VALHALLA_DEMOS = https://github.com/valhalla/demos/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/gh-pages.tar.gz

define serve-mkdocs
	# Wait a second to let mkdocs have time to build
	# Then open a browser on local machine
	# This is spun off as a child processs
	@(sleep 1; open http://127.0.0.1:8000) &
	# Build, serve and watch is the main thread
	env/bin/mkdocs serve
endef

# Reset entire source directory
clean:
	rm -rf ./src/
	mkdir src
	touch ./src/.gitkeep

get: clean get-tangram get-metro-extracts get-valhalla-demos get-valhalla

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
	$(serve-mkdocs)

# Build and serve metro-extracts docs
metro-extracts: virtualenv
	ln -sf config/metro-extracts.yml ./mkdocs.yml
	$(serve-mkdocs)

# Build and serve metro-extracts docs
valhalla: virtualenv
	ln -sf config/valhalla.yml ./mkdocs.yml
	$(serve-mkdocs)

# Set virtual environment & install dependencies
virtualenv:
	test -d env || virtualenv env
	env/bin/pip install -Ur requirements.txt

.PHONY: tangram
