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

### Using MkDocs watch feature

MkDocs can only build one set of documentation at a time, so there's really no way to build and then watch the entire documentation suite at once. However you can still just watch one set of documentation which is still enough for editing styles or debugging.

```shell
make clean dist-tangram                 # Prepares documentation, in this case it's tangram
mkdocs serve -f dist-tangram-mkdocs.yml # Run the server with watch
```

### Customizing templates

We've heavily customized the MkDocs theme for use with Mapzen documentation. Resources for helping this happen are a little scattered so here is an attempt to gather all the relevant information in one spot.

- [MkDocs custom themes](http://www.mkdocs.org/user-guide/styling-your-docs/#custom-themes). This includes all the variables that MkDocs makes available to templates.
- [Jinja2 templating language](http://jinja.pocoo.org/docs/dev/). MkDocs uses Jinja2. This is very similar to Jekyll's Liquid syntax, but it's not the same! ...so it's very easy to get them confused sometimes.
- [MkDocs built-in themes source](https://github.com/mkdocs/mkdocs/tree/master/mkdocs/themes). These are the built-in themes source code. Don't start from scratch, refer to these!
- [MkDocs Bootswatch themes source](https://github.com/mkdocs/mkdocs-bootswatch/tree/master/mkdocs_bootswatch). These are additional [Bootswatch](https://bootswatch.com/) themes that are not included by default. However they might provide additional references for good practices.
