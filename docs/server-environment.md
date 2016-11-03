# Set up your development environment

As you begin writing code, there will be a time when you need to set up a local development environment on your computer. This will involve setting up a local server to test your code and a remote server to share that code with others.

## Start a local web server

Sometimes, you need to set up a web server on your own machine, especially when you need to run JavaScript or other code properly. To start the server, you will need to enter a few command line instructions using the terminal window. 

1. Open a terminal window to the folder containing the files you need to serve. You can type `cd` and the pathname to navigate to the proper directory path.
2. At the prompt, type `python -m SimpleHTTPServer` to start a web server using Python. You should receive a message similar to this in the terminal: `Serving HTTP on 0.0.0.0 port 8000 ...`
3. Open your browser to `http://localhost:8000`. (“Localhost” is a shortcut hostname that a computer can use to refer to itself, and is not viewable by anyone else.) If it was successful, you should see the same demo map as you viewed earlier. If you are having problems, you can instead try the command `python -m http.server 8000` (for use with Python 3).
4. As soon as you close the terminal window, this server will close. Leave your terminal window open as you work.
    
_Tip:  By default, terminal windows open into your home directory, so you will need to drill into the folder structure to get to the simple-demo folder. Alternatively, add a shortcut to your context menu so you can right-click a folder in Finder and start the terminal window in that location. To enable this, open System Preferences, click Keyboard, and click Shortcuts. In the list, click Services and check New Terminal at Folder._

## Use a remote web server

There are many options for getting your map or other project onto the web where it can be shared with others. Use whichever fits your situation best.

**Option 1**: [bl.ocks.org](https://bl.ocks.org). 

This site is a view for code hosted as [GitHub Gist](https://gist.github.com/). 

1. Go to [https://gist.github.com](https://gist.github.com).  
2. Add your HTML page. Call it `index.html` and copy and paste in your HTML code.
3. Click `Add file` to include additional files.
4. When you are finished, click `Create public gist`.  The page will reload with your saved file, known as a gist.
5. In your browser's navigation bar, replace `gist.github.com` with `bl.ocks.org`. You are changing  `https://gist.github.com/<username>/<id>` to `https://bl.ocks.org/<username>/<id>`.
6. View your page at `https://bl.ocks.org/<username>/<id>`

_Tip: You can also try [blockbuilder.org](http://blockbuilder.org/), which automates the gist to bl.ocks workflow for you._

**Option 2**: [Dropbox](https://www.dropbox.com/) 

You can use Dropbox's web servers to host your files. That public link you copied can be viewed by anyone who has the link.

1. Save your project files to your public directory of Dropbox.
2. Right-click (or _&#8984; + click_) on the main HTML file, such as `index.html`, and click `Copy Public Link`.
3. Paste that link into your browser.

**Option 3**: GitHub Pages

[GitHub Pages](https://help.github.com/articles/what-is-github-pages/) is a free hosting service for repositories stored on GitHub. You can use GitHub pages for a variety of projects, including your personal blog or a corporate website.

You need to specify the source of the files used to build the website. In the simplest workflow, you can publish the site from one of these two sources:

- the entire master branch, which is useful if the repository only contains files used for the website
- the contents of a folder named `docs` in the master branch, if you are hosting documentation

Add your files to the repository, and enable GitHub Pages from the repository settings page.

You can also store your files in a `gh-pages` branch, which is a special branch that automatically creates GitHub Pages websites. 
