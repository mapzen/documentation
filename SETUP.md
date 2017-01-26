# Set up and build documentation

## Follow the writing instructions

- Follow the guidelines of the [writing style guide](https://github.com/mapzen/styleguide/tree/master/src/site/guides) when it comes to writing technical documentation.
- Include an `index.md` file at the root folder of your documentation. (Note: [MkDocs will allow this to be customized in the future.](https://github.com/mkdocs/mkdocs/issues/608))
- Start each page with a top-level heading with one `#` symbol, except for the index.md. The home page should not have a title because it would most likely duplicate the banner on the page.
- Follow the [Markdown formatting guide](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- Add blank lines between different blocks of content: before and after bulleted lists, numbered lists, code blocks, images, and so on.
- If a code block or image is supposed to be part of a list, remember the blank lines before and after, and also indent it four spaces. Using or mixing tabs might cause problems. Python Markdown is a lot pickier about this than GitHub-flavored Markdown, causing lists to nest improperly or break numbering altogether.

## Add a new section to the documentation

Adding an entirely new section of the help has many factors, ranging from design decisions on the mapzen.com website to the mechanics of building the help. In general, there are four files that you need to update to do this. You can often copy, paste, and modify existing files to understand what needs to be updated to add the new section.

1. Add an entry to https://github.com/mapzen/documentation/tree/master/src-index to update the index file that is the landing page for the documentation.
2. Add a new config `.yml` file to https://github.com/mapzen/documentation/tree/master/config. This builds the table of contents and sets the links to the source files so the `Edit this page on GitHub` links work properly (these allow users to go directly to the source file to propose edits).
3. Update the Makefile in https://github.com/mapzen/documentation/blob/master/Makefile that pulls together all resources for the help.
4. Update the automated test at https://github.com/mapzen/documentation/blob/master/run-checklist.py.

If you are removing sections from the help, you will need to consider adding URL redirects to the `index.yml` file.

## Add an entry to the documentation table of contents

To display on the documentation site, you need to add a topic to a configuration file. Otherwise, the topic exists only in the repository. It is fine to have topics in the repository that are not in the help system, as long as you know that is happening.

You need to update the config.yml file to add a topic, remove one, or rename it in the table of contents.

1. Go to https://github.com/mapzen/documentation/tree/master/config
2. Find the .yml file for your section of help. For example, Mapzen Mobility can be found in mobility.yml.
3. Under `pages:`, make the change to the table of contents. The topic in the `Home:` position should always be only `index.md` (under MkDocs rules). Add topics by including a heading, contained in single quotation mark, followed by a colon and the name of the md file. For example, `'API reference': 'api-reference.md'`
4. You can add nesting in the table of contents by indenting the lines underneath the heading.

```json
- Concept overviews:
  - 'The Scene file': 'Scene-file.md'
```

File names are case-sensitive, so 'Scene-file.md' is different from 'scene-file.md'. The file name in the config file must exactly match the source file, or else you will get a build error.

### Preview content changes that are in a branch

If you've created a pull request in the documentation repository, and your content changes are in the branch that the help is built from (usually, master), you can view changes at [precog.mapzen.com/mapzen/documentation/](precog.mapzen.com/mapzen/documentation/). 

If the content changes are in a different branch, you need to make temporary changes to the build process to locate your branch. 

1. Create a branch in the `documentation` repository.
1. Open the Makefile
2. In another tab, open the latest commit on the branch you're working on in the particular project repository
3. Copy the full commit ID
4. In the Makefile, edit the URL and replace the phrase (typically, 'master') before .tar.gz with the commit ID, for example:

`EXTRACTS = https://github.com/mapzen/metro-extracts/archive/master.tar.gz --> EXTRACTS = https://github.com/mapzen/metro-extracts/archive/2d3ef32e1a6fc51be6908968e32902a04a016dee.tar.gz`

Note: If you are modifying the `VALHALLA` section, you will need to add a variable for it because the elevation documentation will break. 

## Add URL redirects when you rename or move files

Mapzen wrote some additional Python code to enable URLs to forward when files are renamed or moved. For example, the existing Turn-by-Turn, Optimized Route, and Matrix sections of the help were grouped under a Mobility section when they were packaged into a product called Mapzen Mobility. Because adding mobility changed the URLs, redirects allowed the previous topics to be found in the new help.

For example, https://mapzen.com/documentation/turn-by-turn/api-reference/ redirects to https://mapzen.com/documentation/mobility/turn-by-turn/api-reference/ (note the mobility in the URL).

You will also need to do this when a file is removed or renamed in GitHub, and it has existed long enough that users may have bookmarked it or it can be found through search engines.

1. Go to https://github.com/mapzen/mapzen-docs-generator/tree/master/config
2. Find the .yml file for your section of help. For example, Mapzen Mobility can be found in mobility.yml.
3. Look for a section named `mz:redirects:`. If one is not present, add it after the `pages:` section.
4. Add a new line underneath, indent, and add the portion of the current URL to redirect, followed by a colon and the new URL.

Here is a sample from the mobility.yml.

```
mz:redirects:
  'turn-by-turn': 'turn-by-turn/api-reference'
  'matrix': 'matrix/api-reference'
  'optimized': 'optimized/api-reference'
```

Behind the scenes, this calls setup-redirects.py during the build process.

The base URL for all help is https://mapzen.com/documentation.
This means that the base URL + left part of the colon is https://mapzen.com/documentation/turn-by-turn.

When the script runs, the URL will redirect to the base URL + this section name from the config file (/mobility/) + the right side of the colon. This forms https://mapzen.com/documentation/mobility/turn-by-turn/api-reference.

Similarly, for the `matrix` entry, https://mapzen.com/documentation/matrix will redirect to https://mapzen.com/documentation/mobility/matrix/api-reference.

Note: you must use the redirects functionality anytime you are adding topics that fall under the mobility/turn-by-turn section of help because it takes on a different URL structure than the GitHub repository.

Note: if you completely remove a section from the help, you should put your `mz:redirects` in the `index.yml` file. For example, the `turn-by-turn.yml` file was deleted during a product reorganization process, so redirects from that section of help are in `index.yml`.

## Use a URL structure different from the source file organization

MkDocs uses the exact file name and folder structure from the folder repository to build the URL for the help. This means that a file called `map_basics.md` becomes `/map_basics` with an underscore in the output documentation, when the URLs should ideally only have hyphens.

If you group markdown files in a folder in GitHub, the files will also have this structure in the URL. For example, if you have a folder called `api-reference-docs` with a file in it called `map-basics.md`, the output URL will include `api-reference-docs/map-basics`. In some cases, this adds unnecessary complexity and inconsistency in the URLs.

The simplest way around this is to rename or move the files in GitHub. When changing the source does not make sense, use the functions in the help build process.

1. Go to https://github.com/mapzen/mapzen-docs-generator/tree/master/config
2. Find the .yml file for your section of help. For example, Mapzen Mobility can be found in mobility.yml.
3. Look for a section named `mz:renames:`. If one is not present, add it before the `pages:` section.
4. Add a new line underneath, indent, and add the portion of the current URL to redirect, followed by a colon and the new path or filename.
5. In the `pages:` section, use the new name of the file.

Here is a sample from the mobility.yml.

```
mz:renames:
  'optimized_route/api-reference.md': 'optimized/api-reference.md'
  'api-reference.md': 'turn-by-turn/api-reference.md'
```

When the script runs, it will look in the GitHub source files for a folder named `optimized_route` (note the underscore) and a file in it called `api-reference.md`. It will then output to a temporary location during the build process a folder called `optimized` with the file in it still named `api-reference.md`. If you needed to rename the file, you could do that, too.

In the second entry, it will look at the root level of the GitHub source for a file called `api-reference.md` and output it to a folder named `turn-by-turn`.

## Change the documentation source location permanently

If you move content or rename a repository, you need to update the source location to make the documentation build succeed and see your changes.

1. Update the project configuration file. This is located at `config/project-name.yml` file. Look for the `extra` key and find or create, one level in, the `docs_base_url` key. This is used to build the `Edit this page on GitHub` links at the bottom of each page. It will look something like this:

    ```yml
    extra:
      docs_base_url: https://github.com/mapzen/mapzen-docs/tree/master/metro-extracts
    ```

2. Update the repository path in the Makefile.
3. Create redirects, if necessary. Sometimes you have to change names for the files or move files into other folders, or you delete a file. You should make a redirect link so users can find the new topic. If you need to create a different path in the documentation output than the file name or folder system, consider whether you should make these changes in the GitHub repository first.

## Makefile reference

The Makefile collects and builds the documentation. Here are the general steps it takes. 

- It first retrieves the source documentation file, which is available from GitHub inside a pre-packaged archive with the extension `tar.gz`. 
    
    `TANGRAM = https://github.com/tangrams/tangram-docs/archive/gh-pages.tar.gz`
    
- It uncompresses the file, with a line further down in the Makefile that looks something like this. This will extract the files into the `src/project-name` directory, which makes them available to mkdocs. 

    `curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-gh-pages/pages`
    
You can use this line to change the branch used as the source of the documentation with these lines, which can be handy for testing purposes. This is accomplished by replacing `gh-pages` with the name of another branch. Note that you'll need to convert any slashes in the branch name to dashes. For example, if your repo name is `tangram-docs` and your branch name is `cleanup`, the reference in the `curl` command will look like `tangram-docs-cleanup`, and the full command will be:

`curl -sL $(TANGRAM) | tar -zxv -C src-tangram --strip-components=2 tangram-docs-cleanup/pages`
