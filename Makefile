# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
EXTRACTS = https://github.com/mapzen/metro-extracts/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/master.tar.gz
VECTOR = https://github.com/mapzen/vector-datasource/archive/v0.10.2.tar.gz
SEARCH = https://github.com/pelias/pelias-doc/archive/master.tar.gz
ANDROID = https://github.com/mapzen/android/archive/master.tar.gz
MAPZENJS = https://github.com/mapzen/mapzen.js/archive/master.tar.gz
OVERVIEW = https://github.com/mapzen/mapzen-docs-generator/archive/master.tar.gz

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
	curl -sL $(MAPZENJS) | tar -zxv -C src-mapzen-js --strip-components=2 mapzen.js-master/docs

src-overview:
	mkdir src-overview
	curl -sL $(OVERVIEW) | tar -zxv -C src-overview --strip-components=2 mapzen-docs-generator-master/docs

# Retrieve style guide
theme/fragments:
	mkdir -p theme/fragments
	curl -sL 'https://mapzen.com/site-fragments/navbar.html' -o theme/fragments/global-nav.html
	curl -sL 'https://mapzen.com/site-fragments/footer.html' -o theme/fragments/global-footer.html

# Build tangram docs
dist-tangram: src-tangram theme/fragments
	anyconfig_cli ./config/default.yml ./config/tangram.yml --merge=merge_dicts --output=./dist-tangram-mkdocs.yml
	mkdocs build --config-file ./dist-tangram-mkdocs.yml --clean
	./setup-redirects.py ./dist-tangram-mkdocs.yml /documentation/tangram/

# Build metro-extracts docs
dist-metro-extracts: src-metro-extracts theme/fragments
	anyconfig_cli ./config/default.yml ./config/metro-extracts.yml --merge=merge_dicts --output=./dist-metro-extracts-mkdocs.yml
	mkdocs build --config-file ./dist-metro-extracts-mkdocs.yml --clean
	./setup-redirects.py ./dist-metro-extracts-mkdocs.yml /documentation/metro-extracts/

# Build vector-tiles docs
dist-vector-tiles: src-vector-tiles theme/fragments
	anyconfig_cli ./config/default.yml ./config/vector-tiles.yml --merge=merge_dicts --output=./dist-vector-tiles-mkdocs.yml
	mkdocs build --config-file ./dist-vector-tiles-mkdocs.yml --clean
	./setup-redirects.py ./dist-vector-tiles-mkdocs.yml /documentation/vector-tiles/

# Build elevation service docs
dist-elevation: src-elevation theme/fragments
	anyconfig_cli ./config/default.yml ./config/elevation.yml --merge=merge_dicts --output=./dist-elevation-mkdocs.yml
	mkdocs build --config-file ./dist-elevation-mkdocs.yml --clean
	./setup-redirects.py ./dist-elevation-mkdocs.yml /documentation/elevation/

# Build Search/Pelias docs
dist-search: src-search theme/fragments
	anyconfig_cli ./config/default.yml ./config/search.yml --merge=merge_dicts --output=./dist-search-mkdocs.yml
	mkdocs build --config-file ./dist-search-mkdocs.yml --clean
	./setup-redirects.py ./dist-search-mkdocs.yml /documentation/search/

# Build Mobility docs
dist-mobility: src-mobility theme/fragments
	anyconfig_cli ./config/default.yml ./config/mobility.yml --merge=merge_dicts --output=./dist-mobility-mkdocs.yml
	./setup-renames.py ./dist-mobility-mkdocs.yml
	mkdocs build --config-file ./dist-mobility-mkdocs.yml --clean
	./setup-redirects.py ./dist-mobility-mkdocs.yml /documentation/mobility/

# Build Android docs
dist-android: src-android theme/fragments
	anyconfig_cli ./config/default.yml ./config/android.yml --merge=merge_dicts --output=./dist-android-mkdocs.yml
	mkdocs build --config-file ./dist-android-mkdocs.yml --clean
	./setup-redirects.py ./dist-android-mkdocs.yml /documentation/android/

# Build Mapzen.js docs
dist-mapzen-js: src-mapzen-js theme/fragments
	anyconfig_cli ./config/default.yml ./config/mapzen-js.yml --merge=merge_dicts --output=./dist-mapzen-js-mkdocs.yml
	mkdocs build --config-file ./dist-mapzen-js-mkdocs.yml --clean
	./setup-redirects.py ./dist-mapzen-js-mkdocs.yml /documentation/mapzen-js/

# Build general Mapzen docs
dist-overview: src-overview theme/fragments
	anyconfig_cli ./config/default.yml ./config/overview.yml --merge=merge_dicts --output=./dist-overview-mkdocs.yml
	mkdocs build --config-file ./dist-overview-mkdocs.yml --clean
	./setup-redirects.py ./dist-overview-mkdocs.yml /documentation/overview/

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
	# Compress all HTML files - controls Jinja whitespace
	find -L dist -name \*.html -ls -exec htmlmin --keep-optional-attribute-quotes {} {} \;

serve:
	@mkdocs serve

.PHONY: all clean serve
