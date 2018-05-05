#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import yaml
import sys

with open(sys.argv[1], 'rb')as f:
	yml=yaml.load(f)
quote = yml['quote']
if not quote:
	quote = ""
quote = quote.encode('utf-8').decode()
print(quote)