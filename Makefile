# Source doc tarballs
TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz
EXTRACTS = https://github.com/mapzen/metro-extracts/archive/master.tar.gz
VALHALLA = https://github.com/valhalla/valhalla-docs/archive/master.tar.gz
VALHALLA_TEMP = https://github.com/valhalla/valhalla-docs/archive/transit.tar.gz
VECTOR_TILES = https://api.github.com/repos/tilezen/vector-datasource/releases/latest
TERRAIN_TILES = https://api.github.com/repos/tilezen/joerd/releases/latest
SEARCH = https://github.com/pelias/pelias-doc/archive/master.tar.gz
ANDROID = https://github.com/mapzen/android/archive/master.tar.gz
IOS = https://github.com/mapzen/ios/archive/master.tar.gz
MAPZENJS = https://mapzen.com/js/docs.tar.gz
LIBPOSTAL = https://github.com/whosonfirst/go-whosonfirst-libpostal/archive/master.tar.gz
CARTOGRAPHY = https://github.com/tangrams/cartography-docs/archive/master.tar.gz

SHELL := /bin/bash # required for OSX
PYTHONPATH := packages:$(PYTHONPATH)

all: dist

clean:
	rm -rf dist theme/fragments
	rm -rf src-android src-ios src-elevation src-mapzen-js src-metro-extracts \
	       src-mobility src-search src-tangram src-terrain-tiles \
	       src-vector-tiles src-libpostal src-cartography
	rm -rf dist-android dist-ios dist-elevation dist-index dist-mapzen-js \
	       dist-metro-extracts dist-mobility dist-search dist-tangram \
	       dist-terrain-tiles dist-vector-tiles dist-libpostal dist-cartography
	rm -rf dist-android-mkdocs.yml dist-ios-mkdocs.yml dist-elevation-mkdocs.yml \
	       dist-index-mkdocs.yml dist-mapzen-js-mkdocs.yml \
	       dist-metro-extracts-mkdocs.yml dist-mobility-mkdocs.yml \
	       dist-search-mkdocs.yml dist-tangram-mkdocs.yml \
	       dist-terrain-tiles-mkdocs.yml dist-vector-tiles-mkdocs.yml \
	       dist-libpostal-mkdocs.yml dist-cartography-mkdocs.yml

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
	curl -sL $(VECTOR_TILES) \
	| jq '.tarball_url' --raw-output \
	| xargs curl -sL | ( \
	    tar -zxv -C src-vector-tiles --strip-components=2 --exclude=README.md --wildcards '*/docs/' \
	 || tar -zxv -C src-vector-tiles --strip-components=2 --exclude=README.md '*/docs/' \
	    )

src-terrain-tiles:
	mkdir src-terrain-tiles
	# Try with --wildcards for GNU tar, but fall back to BSD tar syntax for Mac.
	curl -sL $(TERRAIN_TILES) \
	| jq '.tarball_url' --raw-output \
	| xargs curl -sL | ( \
	    tar -zxv -C src-terrain-tiles --strip-components=2 --exclude=README.md --wildcards '*/docs/' \
	 || tar -zxv -C src-terrain-tiles --strip-components=2 --exclude=README.md '*/docs/' \
	    )

src-elevation:
	mkdir src-elevation
	curl -sL $(VALHALLA) | tar -zxv -C src-elevation --strip-components=2 valhalla-docs-master/elevation

src-mobility:
	mkdir src-mobility
	curl -sL $(VALHALLA_TEMP) | tar -zxv -C src-mobility --strip-components=1 valhalla-docs-transit

src-search:
	mkdir src-search
	curl -sL $(SEARCH) | tar -zxv -C src-search --strip-components=1 pelias-doc-master

src-android:
	mkdir src-android
	curl -sL $(ANDROID) | tar -zxv -C src-android --strip-components=2 android-master/docs

src-ios:
	mkdir src-ios
	curl -sL $(IOS) | tar -zxv -C src-ios --strip-components=2 ios-master/docs

src-mapzen-js:
	mkdir src-mapzen-js
	curl -sL $(MAPZENJS) | tar -zxv -C src-mapzen-js --strip-components=1 docs

src-libpostal:
	mkdir src-libpostal
	curl -sL $(LIBPOSTAL) | tar -zxv -C src-libpostal --strip-components=2 go-whosonfirst-libpostal-master/docs

src-cartography:
	mkdir src-cartography
	curl -sL $(CARTOGRAPHY) | tar -zxv -C src-cartography --strip-components=1 cartography-docs-master
	
src-overview:
	cp -r docs/overview src-overview

src-guides:
	cp -r docs/guides src-guides

# Retrieve style guide
theme/fragments:
	mkdir -p theme/fragments
	curl -sL 'https://mapzen.com/site-fragments/new-navbar.html' -o theme/fragments/global-nav.html
	curl -sL 'https://mapzen.com/site-fragments/footer.html' -o theme/fragments/global-footer.html

# Build Tangram, Metro Extracts, Vector Tiles, Elevation, Search, Mobility,
# Android, iOS, Mapzen JS, Terrain Tiles, and Overview docs.
# Uses GNU Make pattern rules:
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

dist: dist-tangram dist-metro-extracts dist-vector-tiles dist-search dist-elevation dist-android dist-ios dist-mapzen-js dist-overview dist-guides dist-index dist-mobility dist-terrain-tiles dist-libpostal dist-cartography
	mkdir dist
	ln -s ../dist-tangram dist/tangram
	ln -s ../dist-metro-extracts dist/metro-extracts
	ln -s ../dist-vector-tiles dist/vector-tiles
	ln -s ../dist-terrain-tiles dist/terrain-tiles
	ln -s ../dist-search dist/search
	ln -s ../dist-elevation dist/elevation
	ln -s ../dist-mobility dist/mobility
	ln -s ../dist-android dist/android
	ln -s ../dist-ios dist/ios
	ln -s ../dist-mapzen-js dist/mapzen-js
	ln -s ../dist-overview dist/overview
	ln -s ../dist-guides dist/guides
	ln -s ../dist-libpostal dist/libpostal
	ln -s ../dist-cartography dist/cartography
	rsync -urv --ignore-existing dist-index/ dist/

serve:
	@mkdocs serve

.PHONY: all clean serve
