# Mapzen's documentation pipeline

We write our documentation in Markdown and store them iin GitHub, and use a [MkDocs](http://www.mkdocs.org/)-based automated workflow to convert them into friendlier static-site documentation pages hosted at https://mapzen.com/documentation/. You can read more about this on our [blog post](https://mapzen.com/blog/doc-site/
).

### Rapid bootstrapping

```shell
# Global dependencies that are needed (optional if you have them already)
# Installing python3 with Homebrew is the easiest way of getting what you need
brew install python3
pip3 install virtualenv

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
open http://localhost:8000/dist/
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

### Customizing templates

We've heavily customized the MkDocs theme for use with Mapzen documentation. Resources for helping this happen are a little scattered so here is an attempt to gather all the relevant information in one spot.

- [MkDocs custom themes](http://www.mkdocs.org/user-guide/styling-your-docs/#custom-themes). This includes all the variables that MkDocs makes available to templates.
- [Jinja2 templating language](http://jinja.pocoo.org/docs/dev/). MkDocs uses Jinja2. This is very similar to Jekyll's Liquid syntax, but it's not the same! ...so it's very easy to get them confused sometimes.
- [MkDocs built-in themes source](https://github.com/mkdocs/mkdocs/tree/master/mkdocs/themes). These are the built-in themes source code. Don't start from scratch, refer to these!
- [MkDocs Bootswatch themes source](https://github.com/mkdocs/mkdocs-bootswatch/tree/master/mkdocs_bootswatch). These are additional [Bootswatch](https://bootswatch.com/) themes that are not included by default. However they might provide additional references for good practices.


## Making MkDocs happy

### You must always:

- Include an `index.md` file at the root folder of your documentation. (Note: [MkDocs will allow this to be customized in the future.](https://github.com/mkdocs/mkdocs/issues/608))
- Include all local documentation assets, such as images, inside this root folder (or link to an external source).
- Start each page with a top-level heading. (Note: The level of heading should no longer affect presentation, but I still need to test whether this affects TOC creation.)

### You will sometimes:

- Think carefully about the choices you made in life.

### Markdown formatting tweaks for compatibility with GitHub

- Blank lines between different blocks of content will be your best friend(s). So, include a blank line before and after bulleted lists, numbered lists, code blocks, images...
- If a code block or image is supposed to be part of a list, remember the blank lines before and after, and _also_ indent it **four spaces**. Using or mixing tabs might cause problems. Python Markdown is a lot pickier about this than GitHub-flavored Markdown, causing lists to nest improperly or break numbering altogether.
- Good luck!

## Updating documentation sources

There are two things to do if you want to change the GitHub source of documentation.

1. **Update the project configuration file.** This is located at `config/project-name.yml` file. Look for the `extra` key and find or create, one level in, the `docs_base_url` key. This is used to build the "edit in GitHub" links at the bottom of each page. The actual path and file name are appended to the base URL. It will look something like this:

    ```yml
    extra:
      docs_base_url: https://github.com/mapzen/mapzen-docs/tree/master/metro-extracts
    ```

2. **Update the repository path in the Makefile.** This is a little harder because it requires some knowledge of shell scripting and `Make`. Generally, we want to first retrieve the source documentation file from GitHub (it's compressed). Next, uncompress it -- extract the files into the `src/project-name` directory. If you're getting files from the mapzen-docs repository, you will have to flatten the directory structure a level up because of how the repository is organized. This step can vary depending on the project, which is why it's not super friendly.
