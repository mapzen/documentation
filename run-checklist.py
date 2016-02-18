#!/usr/bin/env python
from bs4 import BeautifulSoup
from urllib.parse import urlparse, urlunparse, urljoin
from os.path import join, abspath, dirname, relpath, isdir, isfile
from re import compile
import unittest

class HTTP404 (RuntimeError): pass

class SoupServer:
    ''' Stupidest possible directory server thing.
    '''
    def __init__(self, base):
        self.base = abspath(base)
        self.url = '/'
    
    def go(self, path):
        path = urljoin(self.url, path)
        local = join(self.base, relpath(path, '/'))
        
        if isdir(local):
            local = join(local, 'index.html')
        
        if not isfile(local):
            raise HTTP404(path)

        with open(local) as file:
            soup = BeautifulSoup(file, "html.parser")

        path = relpath(local, self.base)
        self.url = '/' + path
        return soup

class Tests (unittest.TestCase):
    
    def setUp(self):
        self.server = SoupServer(join(dirname(__file__), 'dist'))
    
    def _test_doc_section(self, start_path, start_title, next_title):
        '''
        '''
        page1 = self.server.go(start_path)
        url1 = self.server.url
        
        head1 = page1.find(class_=compile(r'\bdocumentation-hero\b')).find('h1')
        self.assertEqual(head1.text, start_title, 'Should be looking at {} page at {}'.format(start_title, self.server.url))
        
        crumbs1 = page1.find('ol', class_=compile(r'\bbreadcrumb\b')).find_all('li')
        self.assertEqual(len(crumbs1), 2, 'There should be two breadcrumbs at top at {}'.format(self.server.url))
        self.assertIsNotNone(crumbs1[0].find('a'), 'The first breadcrumb is a link at {}'.format(self.server.url))
        self.assertIsNone(crumbs1[1].find('a'), 'The last breadcrumb is not a link at {}'.format(self.server.url))
        self.assertEqual(crumbs1[1].text, start_title, 'The last breadcrumb should be {} at {}'.format(start_title, self.server.url))
        
        link1 = page1.find('a', class_=compile(r'\bpagination-link\b'))
        
        if next_title is None:
            self.assertIsNone(link1, 'Should be no pagination link at {}'.format(self.server.url))
            return
        
        self.assertIn(next_title, link1.text, 'First pagination link should go to {} from {}'.format(next_title, self.server.url))
        
        page2 = self.server.go(link1['href'])
        
        head2 = page1.find(class_=compile(r'\bdocumentation-hero\b')).find('h1')
        self.assertIn(start_title, head2.text, 'We should be on a page called {} at {}'.format(start_title, self.server.url))
        
        crumbs2 = page2.find('ol', class_=compile(r'\bbreadcrumb\b')).find_all('li')
        self.assertEqual(len(crumbs2), 3, 'There should be three breadcrumbs at top at {}'.format(self.server.url))
        self.assertIsNotNone(crumbs2[0].find('a'), 'The first breadcrumb is a link at {}'.format(self.server.url))
        self.assertIsNotNone(crumbs2[1].find('a'), 'The second breadcrumb is a link at {}'.format(self.server.url))
        self.assertIsNone(crumbs2[2].find('a'), 'The last breadcrumb is not a link at {}'.format(self.server.url))
        self.assertEqual(crumbs2[2].text, next_title, 'The last breadcrumb should be {} at {}'.format(next_title, self.server.url))

        edit2 = page2.find(string=compile(r'Edit this page on GitHub')).find_parent('a')

        self.assertEqual(urlparse(edit2['href']).hostname, 'github.com', 'Should link to Github.com from {}'.format(self.server.url))
        self.assertTrue(urlparse(edit2['href']).path.endswith('.md'), 'Should link to a Markdown file from {}'.format(self.server.url))
        
        link2 = page2.find('a', class_=compile(r'\bpagination-link\b'))
        self.server.go(link2['href'])
        
        self.assertEqual(self.server.url, url1, 'We should be back where we started')
    
    def test_tangram_index(self):
        self._test_doc_section('/tangram', 'Tangram', 'Walkthrough')
    
    def test_search_index(self):
        self._test_doc_section('/search', 'Mapzen Search', 'Get started')

    def test_turnbyturn_index(self):
        self._test_doc_section('/turn-by-turn', 'Mapzen Turn-by-Turn', 'API reference')

    def test_vectortiles_index(self):
        self._test_doc_section('/vector-tiles', 'Vector Tile Service', 'Get started')

    def test_metroextracts_index(self):
        self._test_doc_section('/metro-extracts', 'Metro Extracts', None)

    def test_elevation_index(self):
        self._test_doc_section('/elevation', 'Elevation Service', None)

    def test_matrix_index(self):
        self._test_doc_section('/matrix', 'Time-Distance Matrix', 'API reference')

if __name__ == '__main__':
    unittest.main()