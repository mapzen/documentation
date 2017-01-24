# Mapzen documentation

Mapzen writes documentation in Markdown, stores the source files in GitHub, and uses a [MkDocs](http://www.mkdocs.org/)-based automated workflow to convert them into static-site documentation pages hosted at https://mapzen.com/documentation/. You can read more about this process in the [blog post](https://mapzen.com/blog/doc-site/).

## Build locally

Clone the repository locally and open a terminal window to the mapzen-docs-generator folder.

On a Mac, assuming you have [Homebrew](http://brew.sh) and 
[Python 3](https://docs.python.org/3/using/mac.html) installed, and a local
checkout of this repository:

```shell
# Prepare virtualenv and install local dependencies
brew install jq
virtualenv -p python3 venv
source venv/bin/activate
pip install -Ur requirements.txt

# Get all the sources and build all the documentation
make

# Use make clean for a fresh build

# Local preview
python -m http.server 8000
open http://localhost:8000/dist/
```

Run `make clean` to build a clean copy of the documentation. This command deletes the previous build and makes new files.

You may be able to build one section of the documentation using `make clean dist-projectname`, such as `make clean dist-tangram`.

## Source files

The source files to build Mapzen's documentation may be found in separate repositories in a GitHub organization, as a documentation folder in a project's repository, or within this repository. Getting changes onto the documentation site may require the files be on a certain branch or in a special release.

|                           Product                        | Source location | Updates  |
|----------------------------------------------------------|---------------------|----------|
| [Overview](http://www.mapzen.com/documentation/overview) | https://github.com/mapzen/mapzen-docs-generator/tree/master/docs  | Push to Master  |
| [Mapzen.js](https://mapzen.com/documentation/mapzen-js/)  | https://github.com/mapzen/mapzen.js/tree/master/docs  | Needs to be in a release  |
| [Tangram](https://mapzen.com/documentation/tangram/) | https://github.com/tangrams/tangram-docs | Push to gh-pages   |
| [Vector Tiles](https://mapzen.com/documentation/vector-tiles/)  | https://github.com/tilezen/vector-datasource/tree/master/docs  | Has versioning |
| [Search](https://mapzen.com/documentation/search/)  | https://github.com/pelias/pelias-doc  | Push to Master  |
| [Mobility](https://mapzen.com/documentation/mobility/)  | https://github.com/valhalla/valhalla-docs  | Push to Master |
| [Metro Extracts](https://mapzen.com/documentation/metro-extracts/)  | https://github.com/mapzen/metro-extracts/tree/master/docs  | Push to Master |
| [Terrain Tiles](https://mapzen.com/documentation/terrain-tiles/)  | https://github.com/tilezen/joerd  | Needs to be in a release  |
| [Elevation Service](https://mapzen.com/documentation/elevation/) | https://github.com/valhalla/valhalla-docs  | Push to Master |
| [Android SDK](https://mapzen.com/documentation/android/) | https://github.com/mapzen/android/tree/master/docs | Push to Master |
