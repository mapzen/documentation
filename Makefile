# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
EXTRACTS = https://github.com/mapzen/metroextractor-cities/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/master.tar.gz
VECTOR = https://github.com/mapzen/vector-datasource/archive/v0.10.2.tar.gz
SEARCH = https://github.com/pelias/pelias-doc/archive/master.tar.gz
ANDROID = https://github.com/mapzen/android/archive/master.tar.gz
GENERAL = https://github.com/mapzen/mapzen-docs-generator/archive/master.tar.gz

SHELL := /bin/bash # required for OSX
PYTHONPATH := packages:$(PYTHONPATH)

all: dist

clean:
	rm -rf dist theme/fragments
	rm -rf src-tangram src-metro-extracts src-vector-tiles \
	       src-turn-by-turn src-elevation src-matrix src-search \
	       src-android
	rm -rf dist-tangram dist-metro-extracts dist-vector-tiles \
	       dist-turn-by-turn dist-search dist-elevation dist-matrix \
	       dist-index dist-android
	rm -rf dist-tangram-mkdocs.yml dist-metro-extracts-mkdocs.yml \
	       dist-vector-tiles-mkdocs.yml dist-turn-by-turn-mkdocs.yml \
	       dist-search-mkdocs.yml dist-elevation-mkdocs.yml \
	       dist-matrix-mkdocs.yml dist-index-mkdocs.yml \
	       dist-android-mkdocs.yml

# Get individual sources docs
src-tangram:
	mkdir src-tangram
	curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-gh-pages/pages

src-metro-extracts:
	mkdir src-metro-extracts
	curl -sL $(EXTRACTS) | tar -zxv -C src-metro-extracts --strip-components=2 metroextractor-cities-master/docs

src-vector-tiles:
	mkdir src-vector-tiles
	curl -sL $(VECTOR) | tar -zxv -C src-vector-tiles --strip-components=2 --exclude=README.md --wildcards '*/docs/'

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

src-android:
	mkdir src-android
	curl -sL $(ANDROID) | tar -zxv -C src-android --strip-components=2 android-master/docs

src-android:
	mkdir src-general
	curl -sL $(GENERAL) | tar -zxv -C src-general --strip-components=2 mapzen-docs-generator-master/docs

# Retrieve style guide
theme/fragments:
	mkdir -p theme/fragments
	curl -sL 'https://mapzen.com/site-fragments/navbar.html' -o theme/fragments/global-nav.html
	curl -sL 'https://mapzen.com/site-fragments/footer.html' -o theme/fragments/global-footer.html

# Build tangram docs
dist-tangram: src-tangram theme/fragments
	anyconfig_cli ./config/default.yml ./config/tangram.yml --merge=merge_dicts --output=./dist-tangram-mkdocs.yml
	mkdocs build --config-file ./dist-tangram-mkdocs.yml --clean

# Build metro-extracts docs
dist-metro-extracts: src-metro-extracts theme/fragments
	anyconfig_cli ./config/default.yml ./config/metro-extracts.yml --merge=merge_dicts --output=./dist-metro-extracts-mkdocs.yml
	mkdocs build --config-file ./dist-metro-extracts-mkdocs.yml --clean

# Build vector-tiles docs
dist-vector-tiles: src-vector-tiles theme/fragments
	anyconfig_cli ./config/default.yml ./config/vector-tiles.yml --merge=merge_dicts --output=./dist-vector-tiles-mkdocs.yml
	mkdocs build --config-file ./dist-vector-tiles-mkdocs.yml --clean

# Build turn-by-turn docs
dist-turn-by-turn: src-turn-by-turn theme/fragments
	anyconfig_cli ./config/default.yml ./config/turn-by-turn.yml --merge=merge_dicts --output=./dist-turn-by-turn-mkdocs.yml
	mkdocs build --config-file ./dist-turn-by-turn-mkdocs.yml --clean

# Build elevation service docs
dist-elevation: src-elevation theme/fragments
	anyconfig_cli ./config/default.yml ./config/elevation.yml --merge=merge_dicts --output=./dist-elevation-mkdocs.yml
	mkdocs build --config-file ./dist-elevation-mkdocs.yml --clean

# Build time-distance matrix service docs
dist-matrix: src-matrix theme/fragments
	anyconfig_cli ./config/default.yml ./config/matrix.yml --merge=merge_dicts --output=./dist-matrix-mkdocs.yml
	mkdocs build --config-file ./dist-matrix-mkdocs.yml --clean

# Build Search/Pelias docs
dist-search: src-search theme/fragments
	anyconfig_cli ./config/default.yml ./config/search.yml --merge=merge_dicts --output=./dist-search-mkdocs.yml
	mkdocs build --config-file ./dist-search-mkdocs.yml --clean

# Build Android docs
dist-android: src-android theme/fragments
	anyconfig_cli ./config/default.yml ./config/android.yml --merge=merge_dicts --output=./dist-android-mkdocs.yml
	mkdocs build --config-file ./dist-android-mkdocs.yml --clean

# Build general Mapzen docs
dist-general: src-general theme/fragments
	anyconfig_cli ./config/default.yml ./config/general.yml --merge=merge_dicts --output=./dist-general-mkdocs.yml
	mkdocs build --config-file ./dist-general-mkdocs.yml --clean

# Build index page
dist-index: theme/fragments
	anyconfig_cli ./config/default.yml ./config/index.yml --merge=merge_dicts --output=./dist-index-mkdocs.yml
	mkdocs build --config-file ./dist-index-mkdocs.yml --clean
	cp dist-index/index.html dist-index/next.html

dist: dist-tangram dist-metro-extracts dist-vector-tiles dist-turn-by-turn dist-search dist-elevation dist-matrix dist-android dist-general dist-index
	cp -r dist-index dist
	ln -s ../dist-tangram dist/tangram
	ln -s ../dist-metro-extracts dist/metro-extracts
	ln -s ../dist-vector-tiles dist/vector-tiles
	ln -s ../dist-turn-by-turn dist/turn-by-turn
	ln -s ../dist-search dist/search
	ln -s ../dist-elevation dist/elevation
	ln -s ../dist-matrix dist/matrix
	ln -s ../dist-android dist/android
	ln -s ../dist-general dist/general
	# Compress all HTML files - controls Jinja whitespace
	find -L dist -name \*.html -ls -exec htmlmin --keep-optional-attribute-quotes {} {} \;

serve:
	@mkdocs serve

.PHONY: all clean serve
