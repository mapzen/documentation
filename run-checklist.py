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
    
    def test_search_index(self):
        '''
        '''
        page1 = self.server.go('/search')
        url1 = self.server.url
        
        head1 = page1.find_all('h1')[-1]
        self.assertEqual(head1.text, 'Mapzen Search', 'Should be looking at Mapzen Search page')
        
        link1 = page1.find('a', class_=compile(r'\bpagination-link\b'))
        self.assertIn('Get started', link1.text, 'First pagination link should go to Get Started')
        
        page2 = self.server.go(link1['href'])
        
        head2 = page2.find_all('h1')[-1]
        self.assertIn('Get started', head2.text, 'We should be on a page called Get Started')
        
        crumbs2 = page2.find('ol', class_=compile(r'\bbreadcrumb\b')).find_all('li')
        self.assertEqual(len(crumbs2), 3, 'There should be three breadcrumbs at top')
        self.assertIsNotNone(crumbs2[0].find('a'), 'The first breadcrumb is a link')
        self.assertIsNotNone(crumbs2[1].find('a'), 'The second breadcrumb is a link')
        self.assertIsNone(crumbs2[2].find('a'), 'The last breadcrumb is not a link')

        edit2 = page2.find(string=compile(r'Edit this page on GitHub')).find_parent('a')

        self.assertEqual(urlparse(edit2['href']).hostname, 'github.com', 'Should link to Github.com')
        self.assertTrue(urlparse(edit2['href']).path.endswith('.md'), 'Should link to a Markdown file')
        
        link2 = page2.find('a', class_=compile(r'\bpagination-link\b'))
        self.server.go(link2['href'])
        
        self.assertEqual(self.server.url, url1, 'We should be back where we started')

if __name__ == '__main__':
    unittest.main()