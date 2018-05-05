#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import sys
from moderncv import ModernCV

cvtype = sys.argv[1]
yaml = sys.argv[2]
md = ""
if cvtype == "moderncv":
	cv = ModernCV(yaml)
	mode = sys.argv[3]
	md = cv.main(mode)

if cvtype == "limecv":
	cv = LimeCV(yaml)
	md = cv.main()

print(md)