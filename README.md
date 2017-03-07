# Mapzen documentation

This repository contains the configuration files and tools used to build Mapzen's documentation site [mapzen.com/documentation](https://mapzen.com/documentation/). 

The documentation is built with an open-source Python tool called [MkDocs](http://www.mkdocs.org/), which formats GitHub markdown files in to a static, HTML website. Note that while MkDocs reads just one source, Mapzen has enhanced it to integrate multiple repositories. There have been additional enhancements to support URL redirects and renaming files in the output help. You can read more about this process in the [blog post](https://mapzen.com/blog/doc-site/).

As long as a markdown file is listed in the build configuration, changes in the source files in the GitHub branch that is being pulled into the help (typically, the master branch) appear automatically on https://mapzen.com/documentation. This is through continuous integration processes that run in the source respositories and in this one.

## Source file locations

The source files to build Mapzen's documentation may be found in separate documentation repositories in a GitHub organization, as a documentation folder in a project's repository, or within this repository. Getting changes onto the documentation site may require the files be on a certain branch or in a release.

|                           Documentation section                       | Source location | Branch name or release  |
|----------------------------------------------------------|---------------------|----------|
| [Overview](http://www.mapzen.com/documentation/overview) | https://github.com/mapzen/mapzen-docs-generator/tree/master/docs  | Master  |
| [Mapzen.js](https://mapzen.com/documentation/mapzen-js/)  | https://github.com/mapzen/mapzen.js/tree/master/docs  | Latest release  |
| [Tangram](https://mapzen.com/documentation/tangram/) | https://github.com/tangrams/tangram-docs | gh-pages   |
| [Vector tiles](https://mapzen.com/documentation/vector-tiles/)  | https://github.com/tilezen/vector-datasource/tree/master/docs  | Latest release |
| [Search](https://mapzen.com/documentation/search/)  | https://github.com/pelias/pelias-doc  | Master  |
| [Mobility](https://mapzen.com/documentation/mobility/)  | https://github.com/valhalla/valhalla-docs  | Master |
| [Metro Extracts](https://mapzen.com/documentation/metro-extracts/)  | https://github.com/mapzen/metro-extracts/tree/master/docs  | Master |
| [Terrain tiles](https://mapzen.com/documentation/terrain-tiles/)  | https://github.com/tilezen/joerd  | Latest release  |
| [Elevation](https://mapzen.com/documentation/elevation/) | https://github.com/valhalla/valhalla-docs  | Master |
| [Android SDK](https://mapzen.com/documentation/android/) | https://github.com/mapzen/android/tree/master/docs | Latest release |
| [iOS SDK](https://mapzen.com/documentation/ios/) | https://github.com/mapzen/ios/blob/master/docs | Latest release |
| [Address parsing/libpostal](https://mapzen.com/documentation/libpostal/) | https://github.com/whosonfirst/go-whosonfirst-libpostal/blob/master/docs | Master |
| [Who's On First](https://mapzen.com/documentation/wof/) | https://github.com/whosonfirst/whosonfirst-www-api/tree/master/docs | Master |
| [Cartography](https://mapzen.com/documentation/cartography/) | https://github.com/tangrams/cartography-docs/ | Master |

## Build locally

If you need to build the documentation locally for testing, clone this repository and open a terminal window to the `documentation` folder.

On a Mac, assuming you have [Homebrew](http://brew.sh) and 
[Python 3](https://docs.python.org/3/using/mac.html) installed, and a local
checkout of this repository:

```shell
# Prepare virtualenv and install local dependencies
virtualenv -p python3 venv
source venv/bin/activate
pip install -Ur requirements.txt

# Get all the sources and build all the documentation
make

# Use `make clean all` for a fresh build

# Local preview
python -m http.server 8000
open http://localhost:8000/dist/
```

Run `make clean all` to build a clean copy of the documentation. This command deletes the previous build and makes new files.

You may be able to build one section of the documentation using `make clean dist-{projectname}`, such as `make clean dist-tangram`.
