# mapzen-docs-generator

Mapzen documentation pipeline.

**Current documentation generator:** [MkDocs](http://www.mkdocs.org/)

### Rapid bootstrapping

```shell
# Dependencies that are needed (optional if you have them already)
sudo easy_install pip
sudo pip install virtualenv

# Clone repository
git clone https://github.com/mapzen/mapzen-docs-generator.git
cd mapzen-docs-generator

# Get all the sources
make get

# Build all the documentations
make all

# Local preview
python -m SimpleHTTPServer 8000
open http://localhost:8000/build/

# Deploy preview pages to GitHub pages
make ghpages
```

**NOTE:** `make` depends on `virtualenv` to be on the system so that the dependencies of MkDocs can be automatically downloaded and installed locally into the `./env/` directory.

## Making MkDocs happy

### You must always:

- Include an `index.md` file at the root folder of your documentation.
- Include all local documentation assets, such as images, inside this root folder (or link to an external source).
- Start each page with a top-level heading.

### You will sometimes:

- Think carefully about the choices you made in life.

### Markdown formatting tweaks for compatibility with GitHub

- Good luck!
