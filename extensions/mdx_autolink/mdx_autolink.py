"""
Autolink Extension
==================

A Python-Markdown extension to automatically create links in text.
Initial goal is to mimic GitHub-flavored Markdown:

  - If you see a link, make it work
  - If it's inside of `backticks`, don't
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

urlfinder = re.compile(r'(https?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.\-#?=&%]*[^\.)\s])\/?)')

# What it's doing. This is descriptive, not necessarily prescriptive behavior.
# Matches only URLs prepended with http:// or https://
# Anything that looks like a domain.name
# Any combination of URL-friendly characters, but a non-exhaustive list:
#  - inner periods are OK
#  - dashes are OK
#  - # for anchor hashes
#  - ?, =, & for query strings
#  - % for escaped characters
#  - But NOT any period or closing parenthesis (from Markdown) followed by whitespace
# Trailing slashes are OK

class URLify(Preprocessor):
    def run(self, lines):
        return [urlfinder.sub(r'<\1>', line) for line in lines]


class AutolinkExtension(Extension):
    def extendMarkdown(self, md, md_globals):
        md.preprocessors.add('urlify', URLify(md), '_end')


def makeExtension(*args, **kwargs):
    return AutolinkExtension(*args, **kwargs)
