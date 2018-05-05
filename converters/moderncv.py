#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import sys
from cv import CV

class ModernCV(CV):
    def entry(self, item, mode="classic"):
        for i in item['entrys']:
            if mode == "banking":
                self.md = self.md + "\cventry{" + i['date'] + "}{" + i['section'] + "}{" + i['entry'] + "}{" + i['title'] + "}{" + i['major'] + "}{" + self.tostr(i['desc']) + "}\n"
            else:
                self.md = self.md + "\cventry{" + i['date'] + "}{" + i['entry'] + "}{" + i['section'] + "}{" + i['title'] + "}{" + i['major'] + "}{" + self.tostr(i['desc']) + "}\n"
        
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

    def doubleitem(self, item, mode="skill"):
        entry_dict = {}
        entry_list = []
        
        if mode == "skill":
            for t in item['entrys']:
                tag = t['tag']
                if tag not in entry_dict:
                    entry_dict[tag] = []
                entry_dict[tag].append(t['item'])
                    
            for k,v in entry_dict.items():
                d = {"item": k, "desc": "，".join(v)}
                entry_list.append(d)
        if mode == "interest":
            for t in item['entrys']:
                d = {"item": t['item'], "desc": t['desc']}
                entry_list.append(d)
        
        l = len(entry_list)
        i = 0
        while i < l-1:
            self.md = self.md + "\cvdoubleitem{" + entry_list[i]['item'] + "}{" + entry_list[i]['desc'] + "}{" +  entry_list[i+1]['item'] + "}{" + entry_list[i+1]['desc'] + "}\n"
            i = i + 2
        
    def itemwithcomment(self, item, mode="classic"):
        for i in item['entrys']:
            self.md = self.md + "\cvitemwithcomment{" + i['item'] + "}{" + i['desc'] + "}{" + i['comment'] + "}\n"
            
    def main(self, mode="classic"):
        for i in self.spec:
            f = i['type']
            self.md = self.md + "\n# " + i['title'] + '\n'
            if f == 'education' or f == "experience":
                self.entry(i,mode)
            if f == 'project':
                self.project(i,mode)
            if f == 'cvitem':
                self.cvitem(i,mode)
            if f == 'skill':
                self.doubleitem(i,"skill")
            if f == 'interest':
                self.doubleitem(i,"interest")
            if f == 'language':
                self.itemwithcomment(i,mode)
        return self.md
            
if __name__ == '__main__':
    cv = ModernCV(sys.argv[1])
    md = cv.main(sys.argv[2])
    print(md)