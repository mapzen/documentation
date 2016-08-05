#!/usr/bin/env python
from urllib.parse import urljoin
from os.path import join, dirname, exists
from os import makedirs
import yaml, argparse

template = '''<!DOCTYPE html>
<meta charset="utf-8">
<title>Redirecting...</title>
<link rel="canonical" href="{href}">
<meta http-equiv="refresh" content="0; url={href}">
<h1>Redirecting...</h1>
<a href="{href}">Click here if you are not redirected.</a>
<script>location="{href}"</script>
'''

def setup_redirect(old_path, new_href):
    if exists(old_path):
        print('Will not overwrite', old_path)
        return
    
    if not exists(dirname(old_path)):
        makedirs(dirname(old_path))
    
    with open(old_path, 'w') as output:
        output.write(template.format(href=new_href))

    print('Redirecting from', old_path, 'to', new_href)

parser = argparse.ArgumentParser(description='Prepare some redirects.')
parser.add_argument('config', help='Configuration file path')
parser.add_argument('base', help='Output documentation base path')

if __name__ == '__main__':
    args = parser.parse_args()
    
    with open(args.config) as input:
        config = yaml.safe_load(input)
        site_dir = config.get('site_dir')
        
        for (old_name, new_name) in config.get('redirects', {}).items():
            old_path = join(site_dir, old_name, 'index.html')
            new_href = urljoin(args.base, new_name)
            setup_redirect(old_path, new_href)
