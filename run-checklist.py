#!/usr/bin/env python
from bs4 import BeautifulSoup
from urllib.parse import urlparse, urlunparse, urljoin
from os.path import join, abspath, dirname, relpath, isdir, isfile
from re import compile
import unittest, yaml

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
    
    def _load_doc_titles(self, path):
        '''
        '''
        with open(path) as file:
            config = yaml.load(file)
            site_name = config['site_name']
            
            if config.get('include_next_prev') is not False:
                (page2_title, ) = config['pages'][1].keys()
            else:
                page2_title = None
        
        return site_name, page2_title
    
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
        
        anchor1a = page1.find('footer').find(string=compile(r'Documentation')).find_parent('a')
        anchor1b = page1.find('footer').find(string=compile(r'GitHub')).find_parent('a')
        href1a = urljoin(urljoin('https://mapzen.com/documentation/', self.server.url), anchor1a['href'])
        href1b = urljoin(urljoin('https://mapzen.com/documentation/', self.server.url), anchor1b['href'])
        self.assertEqual(href1a, 'https://mapzen.com/documentation/', 'Should link to Mapzen docs')
        self.assertEqual(href1b, 'https://github.com/mapzen/', 'Should link out to Github')
        
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
    
    def test_index(self):
        page = self.server.go('/')
        
        hitboxes = page.find('div', class_='doc-hitboxes').find_all('div', class_='doc-hitbox')
        self.assertEqual(len(hitboxes), 8, 'Should be eight documentation sections')
        
        anchors = [box.find('a') for box in hitboxes]
        titles = [anchor.find('h5').text.strip() for anchor in anchors]

        base = 'https://mapzen.com/documentation/'
        links = {urljoin(base, a['href']): t for (a, t) in zip(anchors, titles)}
        
        self.assertEqual(links['https://mapzen.com/documentation/tangram/'], 'Tangram')
        self.assertEqual(links['https://mapzen.com/documentation/search/'], 'Mapzen Search')
        self.assertEqual(links['https://mapzen.com/documentation/turn-by-turn/'], 'Mapzen Turn-by-Turn')
        self.assertEqual(links['https://mapzen.com/documentation/vector-tiles/'], 'Vector Tile Service')
        self.assertEqual(links['https://mapzen.com/documentation/metro-extracts/'], 'Metro Extracts')
        self.assertEqual(links['https://mapzen.com/documentation/elevation/'], 'Elevation Service')
        self.assertEqual(links['https://mapzen.com/documentation/matrix/'], 'Time-Distance Matrix')
        self.assertEqual(links['https://mapzen.com/documentation/android/'], 'Android SDK')
    
    def test_tangram_index(self):
        pass # self._test_doc_section('/tangram', *self._load_doc_titles('config/tangram.yml'))
    
    def test_search_index(self):
        self._test_doc_section('/search', *self._load_doc_titles('config/search.yml'))

    def test_turnbyturn_index(self):
        self._test_doc_section('/turn-by-turn', *self._load_doc_titles('config/turn-by-turn.yml'))

    def test_vectortiles_index(self):
        self._test_doc_section('/vector-tiles', *self._load_doc_titles('config/vector-tiles.yml'))

    def test_metroextracts_index(self):
        self._test_doc_section('/metro-extracts', *self._load_doc_titles('config/metro-extracts.yml'))

    def test_elevation_index(self):
        self._test_doc_section('/elevation', *self._load_doc_titles('config/elevation.yml'))

    def test_matrix_index(self):
        self._test_doc_section('/matrix', *self._load_doc_titles('config/matrix.yml'))

    def test_android_index(self):
        self._test_doc_section('/android', *self._load_doc_titles('config/android.yml'))

if __name__ == '__main__':
    unittest.main()
