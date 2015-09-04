"""
Autolink Extension
==================

A Python-Markdown extension to automatically create links in text.
Initial goal is to mimic GitHub-flavored Markdown:

  - If you see a link, make it work
  - If it's inside of `backticks`, don't

Copyright 2015 Lou Huang

License: [MIT](http://opensource.org/licenses/MIT)

from __future__ import absolute_import
from __future__ import unicode_literals

from markdown.inlinepatterns import SubstituteTagPattern
from markdown.postprocessors import Postprocessor
from markdown import Extension


BR_RE = r'\n'


class AutolinkExtension(Extension):

    def extendMarkdown(self, md, md_globals):
        br_tag = SubstituteTagPattern(BR_RE, 'br')
        md.inlinePatterns.add('nl', br_tag, '_end')


def makeExtension(*args, **kwargs):
    return AutolinkExtension(*args, **kwargs)
"""

import re
from markdown.preprocessors import Preprocessor
from markdown.extensions import Extension

urlfinder = re.compile(r'((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+(:[0-9]+)?|'
                       r'(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:/[\+~%/\.\w\-_]*)?\??'
                       r'(?:[\-\+=&;%@\.\w_]*)#?(?:[\.!/\\\w]*))?)')

# TODO: Terminate the URL regex if there is a period and immediately after is whitespace or linebreak.

class URLify(Preprocessor):
    def run(self, lines):
        return [urlfinder.sub(r'<\1>', line) for line in lines]


class AutolinkExtension(Extension):
    def extendMarkdown(self, md, md_globals):
        md.preprocessors.add('urlify', URLify(md), '_end')


def makeExtension(*args, **kwargs):
    return AutolinkExtension(*args, **kwargs)
