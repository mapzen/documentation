#!/usr/bin/env python
import yaml, argparse

parser = argparse.ArgumentParser(description='Prepare some redirects.')
parser.add_argument('config', help='Configuration file path')

if __name__ == '__main__':
    args = parser.parse_args()
    
    with open(args.config) as file:
        config = yaml.safe_load(file)
        site_dir = config.get('site_dir')
        
        for (old_path, new_path) in config.get('redirects', {}).items():
            print('redirect from', old_path, 'to', new_path, 'in', site_dir)
    
    exit(0)
