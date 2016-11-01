

## Set up a local web development environment

As you begin writing code, there will be a time when you need to set up a local development environment on your computer. This will involve setting up a text editor to write your code, a local server to test your code, and a remote server to share that code with others.

### Text editor

A text editor is an application that will allow you to edit _plain text_ files.  Microsoft Word and other _rich text_ editors include formatting that will confuse your code. Don't use Word. 

Instead, here are a few recommended editors:

* [Atom](https://atom.io/) (Mac, Windows, Linux) 
* [Sublime Text](https://www.sublimetext.com/) (Mac, Windows, Linux) 
* [Notepad ++](https://notepad-plus-plus.org/download/) (Windows only) 
* [TextWrangler](http://www.barebones.com/products/TextWrangler/) (Mac only) 


### Local web server

Instructions for setting up a (temporary) local web server on your computer:

1. Open up your terminal and navigate to your project folder:

    `cd ~/[path to your project directory]`
    
    _(If you're on a mac, this might be a good time to enable a context menu option in OS X that will allow you to launch a terminal window directly from Finder ([see instructions](http://lifehacker.com/launch-an-os-x-terminal-window-from-a-specific-folder-1466745514)).  Or use a tool like [cdto](https://github.com/jbtule/cdto).)_

2. In your terminal, type: `python -m SimpleHTTPServer 8000` and hit enter
    
    _(If that doesn't work, try: `python -m http.server 8000`)_

3. In your browser, go to [http://localhost:8000/](http://localhost:8000/) 

_Note: This will set up a temporary web server right on your computer.  As soon as you close the terminal window, this server will spin down. So leave your terminal window open as you work._


### Remote web server

There are many options for getting your map or other project onto the web where it can be shared with others. Use whichever fits your situation best.

**Option 1**: Use [bl.ocks.org](https://bl.ocks.org)

1. Go to [https://gist.github.com](https://gist.github.com).  

2. Add your html page. Call it `index.html`  and copy and paste in your html code.

3. Add additional files as needed by using the "Add file" button.

4. When you are finished, click **Create public gist**.  The page will reload with your saved file (i.e., your _gist_).

5. Click into the URL at the top of your browser and replace "gist.github.com" with "bl.ocks.org"

    so that:  **`https://gist.github.com/<username>/<id>`**

    becomes:  **`https://bl.ocks.org/<username>/<id>`**

6. Hit enter to view your page at `https://bl.ocks.org/<username>/<id>`

_Note: Also check out [blockbuilder.org](http://blockbuilder.org/), which automates the gist &rarr; bl.ocks workflow for you._


**Option 2**: Use [Dropbox](https://www.dropbox.com/) 

1. Save your project files to your _Public_ directory of Dropbox

2. Right-click (_&#8984; + click_) on the main html file (e.g., `index.html`) and select “Copy Public Link"

3. Paste that link into your browser and hit enter

_Note: In this option, you are using Dropbox's own web servers to host your files. That public link you copied can be viewed by anyone you send the link to._


**Option 3**: Use GitHub pages? 

