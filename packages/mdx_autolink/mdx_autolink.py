"""
Autolink Extension
==================

A Python-Markdown extension to automatically create links in text.
Initial goal is to mimic GitHub-flavored Markdown:

  - If you see a link, make it work
  - If it's inside of `backticks`, don't

Copyright 2015 Lou Huang

License: [MIT](http://opensource.org/licenses/MIT)
"""

import re
from markdown.preprocessors import Preprocessor
from markdown.extensions import Extension

"""
# Old regex is really long and caused problems
# Retained here for reference
urlfinder = re.compile(r'((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+(:[0-9]+)?|'
                       r'(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:/[\+~%/\.\w\-_]*)?\??'
                       r'(?:[\-\+=&;%@\.\w_]*)#?(?:[\.!/\\\w]*))?)')
"""

urlfinder = re.compile(r'(https?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?)')

# TODO: Terminate the URL regex if there is a period and immediately after is whitespace or linebreak.

class URLify(Preprocessor):
    def run(self, lines):
        return [urlfinder.sub(r'<\1>', line) for line in lines]


class AutolinkExtension(Extension):
    def extendMarkdown(self, md, md_globals):
        md.preprocessors.add('urlify', URLify(md), '_end')


def makeExtension(*args, **kwargs):
    return AutolinkExtension(*args, **kwargs)
