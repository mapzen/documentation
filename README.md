# Mapzen's documentation pipeline

We write our documentation in Markdown and store them in GitHub, and use a [MkDocs](http://www.mkdocs.org/)-based automated workflow to convert them into friendlier static-site documentation pages hosted at https://mapzen.com/documentation/. You can read more about this on our [blog post](https://mapzen.com/blog/doc-site/).

## Installation, Testing, And Use

### Rapid bootstrapping

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

# Local preview
python -m http.server 8000
open http://localhost:8000/dist/
```
You can use `make clean` to run the make process on a specific documentation source

```shell
make clean dist-tangram                 # Prepares documentation, in this case it's tangram

python -m http.server 8000              # local preview
open http://localhost:8000/dist/
```

