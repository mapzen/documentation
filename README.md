# mapzen-docs-generator

Mapzen documentation pipeline.

**Current documentation generator:** [MkDocs](http://www.mkdocs.org/)

### Rapid bootstrapping

```shell
# Global dependencies that are needed (optional if you have them already)
sudo easy_install pip
sudo pip install virtualenv

# Clone repository
git clone https://github.com/mapzen/mapzen-docs-generator.git
cd mapzen-docs-generator

# Install local dependencies
make env

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

### Using MkDocs watch feature

MkDocs can only build one set of documentation at a time, so there's really no way to build and then watch the entire documentation suite at once. However you can still just watch one set of documentation which is still enough for editing styles or debugging.

```shell
make tangram           # Sets the documentation to build and watch, in this case it's tangram
env/bin/mkdocs serve   # Run the server with watch
```

### Building styles

The docs theme borrows styles and view snippets from mapzen.com, primarily for the header and footer, as well as Bootstrap variables that are reused. In addition, there are stylesheets that are specific for documentation. This is all compiled with Sass. Building the compiled CSS file does not happen automatically on each deploy because it is not assumed to change as frequently as documentation content. To update CSS, run locally:

```shell
make css
```

This depends on the `sass` command being available locally so you will have to [install it](http://sass-lang.com/install) if it is not there. This command watches the entire source `theme/scss` folder for changes and compiles CSS. When you are done editing CSS, you can quit the watcher and then commit the compiled file to Git.

## Making MkDocs happy

### You must always:

- Include an `index.md` file at the root folder of your documentation. (Note: [MkDocs will allow this to be customized in the future.](https://github.com/mkdocs/mkdocs/issues/608))
- Include all local documentation assets, such as images, inside this root folder (or link to an external source).
- Start each page with a top-level heading. (Note: The level of heading should no longer affect presentation, but I still need to test whether this affects TOC creation.)

### You will sometimes:

- Think carefully about the choices you made in life.

### Markdown formatting tweaks for compatibility with GitHub

- Good luck!
