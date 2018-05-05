#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import yaml
import sys

class CV(object):
    def __init__(self,cvyaml):
        with open(cvyaml, 'rb')as f:
            yml=yaml.load(f)
        self.md = "% " + yml['title'] + "\n% " + yml['name'] + '\n'
        self.spec = yml['spec']
        
    def entry(self, item, mode="classic"):
        for i in item['entrys']:
            self.md = self.md + i['date'] + "，" + i['entry'] + "，" + i['section'] + "，" + i['title'] + "，" + i['major'] + "\n"
        
    def project(self, item, mode="classic"):
        for i in item['entrys']:
            self.md = self.md + i['date'] + "，" + i['entry'] + "，" + i['corp'] + "，" + i['tech'] + "\n"
            for t in i['items']:
                self.md = self.md + t + '\n'
            self.md = self.md + '\n'
        
    def cvitem(self, item, mode="classic"):
        for i in item['entrys']:
            self.md = self.md + i['cvitem'] + "，" + i['desc'] + "\n"

    def doubleitem(self, item, mode="classic"):
        l = len(item['entrys'])
        i = 0
        while i < l:
            self.md = self.md + item['entrys'][i]['item'] + "，" + item['entrys'][i]['desc'] + "，" +  item['entrys'][i+1]['item'] + "，" + item['entrys'][i+1]['desc'] + "\n"
            i = i + 2
        
    def itemwithcomment(self, item, mode="classic"):
        for i in item['entrys']:
            self.md = self.md + i['item'] + "，" + i['desc'] + "，" + i['comment'] + "\n"
        
    def main(self, mode="classic"):
        for i in self.spec:
            f = i['type']
            self.md = self.md + "\n# " + i['title'] + '\n'
            if f == 'entry':
                self.entry(i,mode)
            if f == 'project':
                self.project(i,mode)
            if f == 'cvitem':
                self.cvitem(i,mode)
            if f == 'doubleitem':
                self.doubleitem(i,mode)
            if f == 'itemwithcomment':
                self.itemwithcomment(i,mode)
        return self.md
    
if __name__ == '__main__':
    cv = CV(sys.argv[1])
    md = cv.main()
    print(md)