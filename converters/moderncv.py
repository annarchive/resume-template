#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import sys
from cv import CV

class ModernCV(CV):
    def entry(self, item, mode="classic"):
        for i in item['entrys']:
            if mode == "banking":
                self.md = self.md + "\cventry{" + i['date'] + "}{" + i['section'] + "}{" + i['entry'] + "}{" + i['title'] + "}{" + i['major'] + "}{}\n"
            else:
                self.md = self.md + "\cventry{" + i['date'] + "}{" + i['entry'] + "}{" + i['section'] + "}{" + i['title'] + "}{" + i['major'] + "}{}\n"
        
    def project(self, item, mode="classic"):
        for i in item['entrys']:
            if mode == "banking":
                self.md = self.md + "\cventry{" + i['date'] + "}{" + i['corp'] + "}{" + i['entry'] + "}{" + i['tech'] + "}{}{\n\\begin{itemize}\n"
            else:
                self.md = self.md + "\cventry{" + i['date'] + "}{" + i['entry'] + "}{" + i['corp'] + "}{" + i['tech'] + "}{}{\n\\begin{itemize}\n"
            for t in i['items']:
                self.md = self.md + '\item ' + t + '\n'
            self.md = self.md + '\end{itemize}\n}\n'
        
    def cvitem(self, item, mode="classic"):
        for i in item['entrys']:
            self.md = self.md + "\cvitem{" + i['cvitem'] + "}{" + i['desc'] + "}\n"

    def doubleitem(self, item, mode="classic"):
        l = len(item['entrys'])
        i = 0
        while i < l:
            self.md = self.md + "\cvdoubleitem{" + item['entrys'][i]['item'] + "}{" + item['entrys'][i]['desc'] + "}{" +  item['entrys'][i+1]['item'] + "}{" + item['entrys'][i+1]['desc'] + "}\n"
            i = i + 2
        
    def itemwithcomment(self, item, mode="classic"):
        for i in item['entrys']:
            self.md = self.md + "\cvitemwithcomment{" + i['item'] + "}{" + i['desc'] + "}{" + i['comment'] + "}\n"
            
if __name__ == '__main__':
    cv = ModernCV(sys.argv[1])
    md = cv.main(sys.argv[2])
    print(md)