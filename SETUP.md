# Set up and documentation update instructions

## Follow MkDocs requirements

- Include an `index.md` file at the root folder of your documentation. (Note: [MkDocs will allow this to be customized in the future.](https://github.com/mkdocs/mkdocs/issues/608))
- Include all local documentation assets, such as images, inside this root folder (or link to an external source).
- Start each page with a top-level heading with one `#` symbol, except for the index.md. The home page should not have a title because it would most likely duplicate the banner on the page.

### Preview the changes on the precog website

If you've created a Pull Request in the mapzen-docs-generator repository, you can view changes in Precog at [precog.mapzen.com/mapzen/mapzen-docs-generator/](precog.mapzen.com/mapzen/mapzen-docs-generator/). This will only show changes that have been done in this specific repository. If the changes you're doing on a particular repository aren't live yet, you need to edit the **Makefile** to reflect the branch that you're working on. You can do this by:

1. Opening the Makefile
2. In another tab, open the latest commit on the branch you're working on in the particular project repository
3. Copy the full commit ID
4. In the mapzen-docs-generator Makefile, edit the URL and replace the phrase (typically 'master') before .tar.gz with the commit ID, for example:

`EXTRACTS = https://github.com/mapzen/metro-extracts/archive/master.tar.gz --> EXTRACTS = https://github.com/mapzen/metro-extracts/archive/2d3ef32e1a6fc51be6908968e32902a04a016dee.tar.gz`

At the moment, this will be needed to be updated with the new commit ID when needed.

## Make your markdown compatible with GitHub and the documentation site

- [Markdown formatting guide](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- Add blank lines between different blocks of content: before and after bulleted lists, numbered lists, code blocks, images, and so on.
- If a code block or image is supposed to be part of a list, remember the blank lines before and after, and _also_ indent it **four spaces**. Using or mixing tabs might cause problems. Python Markdown is a lot pickier about this than GitHub-flavored Markdown, causing lists to nest improperly or break numbering altogether.

## Update the documentation source file

There are two (sometimes three) things to do if you want to change the GitHub source of documentation.

1. **Update the project configuration file.** This is located at `config/project-name.yml` file. Look for the `extra` key and find or create, one level in, the `docs_base_url` key. This is used to build the "edit in GitHub" links at the bottom of each page. The actual path and file name are appended to the base URL. It will look something like this:

    ```yml
    extra:
      docs_base_url: https://github.com/mapzen/mapzen-docs/tree/master/metro-extracts
    ```

2. **Update the repository path in the Makefile.** The Makefile is located in this repo's root, and is called `Makefile`. This step is a little harder and benefits from some knowledge of shell scripting and `Make`. Generally, you want to first retrieve the source documentation file, which is available from GitHub inside a pre-packaged archive with the extension `tar.gz`. You locate it by setting a variable with the file's location, which might look something like this:

    `TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz`

    Next, uncompress it, with a line further down in the Makefile that looks something like this:

    `curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-gh-pages/pages`

    This will extract the files into the `src/project-name` directory, which makes them available to mkdocs. 

    You can also change the branch used as the source of the documentation with these lines, which can be handy for testing purposes. This is accomplished by replacing `gh-pages` with the name of another branch. Note that you'll need to convert any slashes in the branch name to dashes – e.g. if your repo name is `tangram-docs` and your branch name is `meetar/cleanup`, the reference in the `curl` command will look like `tangram-docs-meetar-cleanup`, and the full command will be:

    `curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-meetar-cleanup/pages`

3. **Create redirects if necessary.** Sometimes you have to change names for the files or move files into other folders, or you delete a file. You should make a redirect link so users can find the new topic.
To create a redirect, under the `pages` section of the product's config .yml, add another section called 'mz:redirects'. In this section, add the original markdown file name that you have moved, and then add the page where it should be redirected. Take this example from the `search.yml`, for instance:

    `mz:redirects:
      'get-started': '.'
      'transition-from-beta': '.'``
      
If you need to create a different path in the documentation output than the file name or folder system, consider whether you should make these changes in the GitHub repository first.

## Documentation writing instructions

Follow the guidelines of the [writing style guide](https://github.com/mapzen/styleguide/tree/master/src/site/guides) when it comes to writing technical documentation.
