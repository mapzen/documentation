# Mapzen's documentation pipeline

We write our documentation in Markdown and store them in GitHub, and use a [MkDocs](http://www.mkdocs.org/)-based automated workflow to convert them into friendlier static-site documentation pages hosted at https://mapzen.com/documentation/. You can read more about this on our [blog post](https://mapzen.com/blog/doc-site/).

## Installation, Testing, And Use

### Build locally

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
