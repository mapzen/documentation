#!/usr/bin/env python
import json, sys, pipes

input = json.load(sys.stdin)
value = input.get('tarball_url', '')
output = pipes.quote(value)

print(output)
