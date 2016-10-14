# Mapzen's documentation pipeline

We write our documentation in Markdown and store them in GitHub, and use a [MkDocs](http://www.mkdocs.org/)-based automated workflow to convert them into friendlier static-site documentation pages hosted at https://mapzen.com/documentation/. You can read more about this on our [blog post](https://mapzen.com/blog/doc-site/).

## Status
<img href="https://circleci.com/gh/mapzen/mapzen-docs-generator.svg?style=shield&circle-token=7674367293a932dc152f6663d5361bf8570d4ad6" />

Documentation is generated hourly from a scheduled task attached to the
[Heroku app `mapzen-docs-generator`](https://dashboard.heroku.com/apps/mapzen-docs-generator).

## Where the docs live

Docs live in either individual repositories in a team's organization, or as a folder in a project's repository. Also, depending on the config of the docs, doc updates may be as simple as pushing to master or need to be in a release. Be careful when needing to update!

|                           Product                        | Where does it live? | Updates  |
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

## Installation, Testing, And Use

### View changes in Precog

If you've created a Pull Request in the mapzen-docs-generator repository, you can view changes in Precog at [precog.mapzen.com/mapzen/mapzen-docs-generator/](precog.mapzen.com/mapzen/mapzen-docs-generator/). This will only show changes that have been done in this specific repository, so to track changes in a particular repository, you need to edit the **Makefile** to reflect the branch that you're working on. You can do this by:

1. Opening the Makefile
2. In another tab, open the latest commit on the branch you're working on in the particular project repository
3. Copy the full commit ID
4. In the mapzen-docs-generator Makefile, edit the URL and replace the phrase (typically 'master') before .tar.gz with the commit ID, for example:

`EXTRACTS = https://github.com/mapzen/metro-extracts/archive/master.tar.gz --> EXTRACTS = https://github.com/mapzen/metro-extracts/archive/2d3ef32e1a6fc51be6908968e32902a04a016dee.tar.gz`

At the moment, this will be needed to be updated with the new commit ID when needed.

### Using MkDocs watch feature

MkDocs can only build one set of documentation at a time, so there's really no way to build and then watch the entire documentation suite at once. However you can still just watch one set of documentation which is still enough for editing styles or debugging.

```shell
make dist-tangram                       # Prepares documentation, in this case it's tangram
mkdocs serve -f dist-tangram-mkdocs.yml # Run the server with watch
```

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

- [Handy dandy Markdown formatting guide](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- Blank lines between different blocks of content will be your best friend(s). So, include a blank line before and after bulleted lists, numbered lists, code blocks, images...
- If a code block or image is supposed to be part of a list, remember the blank lines before and after, and _also_ indent it **four spaces**. Using or mixing tabs might cause problems. Python Markdown is a lot pickier about this than GitHub-flavored Markdown, causing lists to nest improperly or break numbering altogether.
- Good luck!

## Updating documentation sources

There are two (sometimes three) things to do if you want to change the GitHub source of documentation.

1. **Update the project configuration file.** This is located at `config/project-name.yml` file. Look for the `extra` key and find or create, one level in, the `docs_base_url` key. This is used to build the "edit in GitHub" links at the bottom of each page. The actual path and file name are appended to the base URL. It will look something like this:

    ```yml
    extra:
      docs_base_url: https://github.com/mapzen/mapzen-docs/tree/master/metro-extracts
    ```

2. **Update the repository path in the Makefile.** The Makefile is located in this repo's root, and is called `Makefile`. This step is a little harder and benefits from some knowledge of shell scripting and `Make`. Generally, we want to first retrieve the source documentation file, which is available from GitHub inside a pre-packaged archive with the extension `tar.gz`. We locate it by setting a variable with the file's location, which might look something like this:

    `TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz`

    Next, we uncompress it, with a line further down in the Makefile that looks something like this:

    `curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-gh-pages/pages`

    This will extract the files into the `src/project-name` directory, which makes them available to mkdocs. If you're getting files from the `mapzen-docs` repository, you will have to flatten the directory structure a level up because of how the repository is organized. This step can vary depending on the project, which is why it's not super friendly.

    You can also change the branch used as the source of the documentation with these lines, which can be handy for testing purposes. This is accomplished by replacing `gh-pages` with the name of another branch. Note that you'll need to convert any slashes in the branch name to dashes – e.g. if your repo name is `tangram-docs` and your branch name is `meetar/cleanup`, the reference in the `curl` command will look like `tangram-docs-meetar-cleanup`, and the full command will be:

    `curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-meetar-cleanup/pages`

3. **Create redirects if necessary.** Sometimes we have to change names for the table of contents and documentation anchors. Time for redirects!
Under the 'pages' section of the product's config .yml, we add another section called 'mz:redirects'. In this section, we add the original markdown file name that we're removing, and then add the page to redirect it to. Take this example from the `search.yml` for instance:

`mz:redirects:
  'get-started': '.'
  'transition-from-beta': '.'``
