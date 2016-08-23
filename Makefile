# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
EXTRACTS = https://github.com/mapzen/metro-extracts/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/master.tar.gz
VECTOR = https://github.com/mapzen/vector-datasource/archive/v0.10.2.tar.gz
SEARCH = https://github.com/pelias/pelias-doc/archive/master.tar.gz
ANDROID = https://github.com/mapzen/android/archive/master.tar.gz
MAPZENJS = https://mapzen.com/js/docs.tar.gz

SHELL := /bin/bash # required for OSX
PYTHONPATH := packages:$(PYTHONPATH)

all: dist

clean:
	rm -rf dist theme/fragments
	rm -rf src-tangram src-metro-extracts src-vector-tiles \
	       src-elevation src-search \
	       src-android src-mapzen-js src-mobility
	rm -rf dist-tangram dist-metro-extracts dist-vector-tiles \
	       dist-search dist-elevation \
	       dist-index dist-android dist-mapzen-js dist-mobility
	rm -rf dist-tangram-mkdocs.yml dist-metro-extracts-mkdocs.yml \
	       dist-vector-tiles-mkdocs.yml  \
	       dist-search-mkdocs.yml dist-elevation-mkdocs.yml \
	       dist-index-mkdocs.yml \
	       dist-android-mkdocs.yml dist-mapzen-js-mkdocs.yml \
	       dist-mobility-mkdocs.yml

# Get individual sources docs
src-tangram:
	mkdir src-tangram
	curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-gh-pages/pages

src-metro-extracts:
	mkdir src-metro-extracts
	curl -sL $(EXTRACTS) | tar -zxv -C src-metro-extracts --strip-components=2 metro-extracts-master/docs

src-vector-tiles:
	mkdir src-vector-tiles
	# Try with --wildcards for GNU tar, but fall back to BSD tar syntax for Mac.
	curl -sL $(VECTOR) | ( \
	    tar -zxv -C src-vector-tiles --strip-components=2 --exclude=README.md --wildcards '*/docs/' \
	 || tar -zxv -C src-vector-tiles --strip-components=2 --exclude=README.md '*/docs/' \
	    )

src-elevation:
	mkdir src-elevation
	curl -sL $(VALHALLA) | tar -zxv -C src-elevation --strip-components=2 valhalla-docs-master/elevation

src-mobility:
	mkdir src-mobility
	curl -sL $(VALHALLA) | tar -zxv -C src-mobility --strip-components=1 valhalla-docs-master

src-search:
	mkdir src-search
	curl -sL $(SEARCH) | tar -zxv -C src-search --strip-components=1 pelias-doc-master

src-android:
	mkdir src-android
	curl -sL $(ANDROID) | tar -zxv -C src-android --strip-components=2 android-master/docs

src-mapzen-js:
	mkdir src-mapzen-js
	curl -sL $(MAPZENJS) | tar -zxv -C src-mapzen-js --strip-components=1 docs

src-overview:
	cp -r docs src-overview

# Retrieve style guide
theme/fragments:
	mkdir -p theme/fragments
	curl -sL 'https://mapzen.com/site-fragments/navbar.html' -o theme/fragments/global-nav.html
	curl -sL 'https://mapzen.com/site-fragments/footer.html' -o theme/fragments/global-footer.html

# Build Tangram, Metro Extracts, Vector Tiles, Elevation, Search, Mobility,
# Android, Mapzen JS, and Overview docs. Uses GNU Make pattern rules:
# https://www.gnu.org/software/make/manual/html_node/Pattern-Examples.html
dist-%: src-% theme/fragments
	anyconfig_cli ./config/default.yml ./config/$*.yml --merge=merge_dicts --output=./dist-$*-mkdocs.yml
	./setup-renames.py ./dist-$*-mkdocs.yml
	mkdocs build --config-file ./dist-$*-mkdocs.yml --clean
	./setup-redirects.py ./dist-$*-mkdocs.yml /documentation/$*/

# Build index page
dist-index: theme/fragments
	anyconfig_cli ./config/default.yml ./config/index.yml --merge=merge_dicts --output=./dist-index-mkdocs.yml
	mkdocs build --config-file ./dist-index-mkdocs.yml --clean
	./setup-redirects.py ./dist-index-mkdocs.yml /documentation/
	cp dist-index/index.html dist-index/next.html

dist: dist-tangram dist-metro-extracts dist-vector-tiles dist-search dist-elevation dist-android dist-mapzen-js dist-overview dist-index dist-mobility
	mkdir dist
	ln -s ../dist-tangram dist/tangram
	ln -s ../dist-metro-extracts dist/metro-extracts
	ln -s ../dist-vector-tiles dist/vector-tiles
	ln -s ../dist-search dist/search
	ln -s ../dist-elevation dist/elevation
	ln -s ../dist-mobility dist/mobility
	ln -s ../dist-android dist/android
	ln -s ../dist-mapzen-js dist/mapzen-js
	ln -s ../dist-overview dist/overview
	rsync -urv --ignore-existing dist-index/ dist/

serve:
	@mkdocs serve

.PHONY: all clean serve
