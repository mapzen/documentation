from __future__ import absolute_import
import unittest

from markdown import markdown, Markdown

from mdx_autolink.mdx_autolink import AutolinkExtension


class AutolinkTest(unittest.TestCase):
    def test_link(self):
        expected = '<p><a href="http://example.com">http://example.com</a></p>'
        actual = markdown("http://example.com", extensions=["autolink"])
        self.assertEqual(expected, actual)

    def test_https_link(self):
        link = "https://example.com"
        expected = '<p><a href="{link}">{link}</a></p>'.format(link=link)
        actual = markdown(link, extensions=["autolink"])
        self.assertEqual(expected, actual)

    def test_complex_link(self):
        link = "http://spam.cheese.bacon.eggs.io/?monty=Python#im_loving_it"
        expected = '<p><a href="{link}">{link}</a></p>'.format(link=link)
        actual = markdown(link, extensions=["autolink"])
        self.assertEqual(expected, actual)

    def test_no_link(self):
        expected = '<p>foo.bar</p>'
        actual = markdown("foo.bar", extensions=["autolink"])
        self.assertEqual(expected, actual)

    def test_links(self):
        expected = ('<p><a href="http://example.com">http://example.com</a> '
                    '<a href="http://example.org">http://example.org</a></p>')
        actual = markdown("http://example.com http://example.org",
                          extensions=["autolink"])
        self.assertEqual(expected, actual)

    def test_links_with_text_between(self):
        expected = ('<p><a href="http://example.com">http://example.com</a> '
                    'foo <a href="http://example.org">http://example.org'
                    '</a></p>')
        actual = markdown("http://example.com foo http://example.org",
                          extensions=["autolink"])
        self.assertEqual(expected, actual)

    def test_existing_link(self):
        expected = '<p><a href="http://example.com">http://example.com</a></p>'
        actual = markdown("[http://example.com](http://example.com)",
                          extensions=["autolink"])
        self.assertEqual(expected, actual)

    def test_image_that_has_link_in_it(self):
        src = "http://example.com/monty.jpg"
        alt = "Monty"

        # Order is not guaranteed so we check for substring existence.
        actual = markdown("![Monty]({})".format(src), extensions=["autolink"])
        self.assertIn(src, actual)
        self.assertIn(alt, actual)

    def test_no_escape(self):
        expected = '<script>alert(1)</script>'
        actual = markdown(expected, extensions=["autolink"])
        self.assertEqual(expected, actual)

    def test_callbacks(self):
        def dont_autolink_txt_extension(attrs, new=False):
            if attrs["_text"].endswith(".txt"):
                return None

            return attrs

        md = Markdown(
            extensions=[AutolinkExtension()],
            extension_configs={
                "autolink": {
                    "autolink_callbacks": [[dont_autolink_txt_extension], ""]
                }
            }
        )

        actual = md.convert("not_link.txt")
        expected = '<p>not_link.txt</p>'
        self.assertEqual(actual, expected)

        actual = md.convert("example.com")
        expected = '<p><a href="http://example.com">example.com</a></p>'
        self.assertEqual(actual, expected)


if __name__ == "__main__":
    unittest.main()
