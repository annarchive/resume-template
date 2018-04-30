import yaml
import sys

with open(sys.argv[1])as f:
    s=yaml.load(f)
print(s)