#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import sys
from cv import CV

class LimeCV(CV):
    def entry(self, item):
        self.mainMd = self.mainMd + "\LimeCVCustomBegin{cvEducation}\n"
        for i in item['entrys']:
            self.mainMd = self.mainMd + "\cvItem{{\\bf " + i['entry'] + "} \\\\\n" + i['section'] + "，" + i['major'] + "，" + i['title'] + "，" + i['date'] + " \\\\\n" + self.tostr(i['desc']) + "}\n"
        self.mainMd = self.mainMd + "\LimeCVCustomEnd{cvEducation}\n"
        
    def project(self, item):
        self.mainMd = self.mainMd + "\LimeCVCustomBegin{cvExperience}\n"
        for i in item['entrys']:
            self.mainMd = self.mainMd + "\cvItem{{\\bf " + i['entry'] + "} \\\\\n" + i['corp'] + "，" + i['tech'] + "，" + i['date'] + " \\\\}\n"
        self.mainMd = self.mainMd + "\LimeCVCustomEnd{cvExperience}\n"
        
    def cvitem(self, item):
        pass
        
    def skill(self, item):
        self.mainMd = self.mainMd + '\LimeCVCustomBegin{cvSkills}\n'
        l = len(item['entrys'])
        i = 0
        while i < l-1:
            self.mainMd = self.mainMd + '\cvSkillTwo{' + str(item['entrys'][i]['score']) + '}{' + item['entrys'][i]['item'] + '}{' + str(item['entrys'][i+1]['score']) + '}{' + item['entrys'][i+1]['item'] + '}\n'
            i = i + 2
        self.mainMd = self.mainMd + '\LimeCVCustomEnd{cvSkills}'
        
    def experience(self, item):
        self.sideMd = self.sideMd + '\LimeCVCustomBegin{cvProjects}\n'
        for i in item['entrys']:
            self.sideMd = self.sideMd + '\cvProject{' + i['entry'] + '}{' + i['date'] + '，' + i['title'] + '}\n'
        self.sideMd = self.sideMd + '\LimeCVCustomEnd{cvProjects}\n'
    
    def interest(self, item):
        self.sideMd = self.sideMd + '\LimeCVCustomBegin{cvInterests}[short]\n\n'
        for i in item['entrys']:
            self.sideMd = self.sideMd + '\cvInterest{\\' + i['icon'] + '}{' + i['item'] + '（' + i['desc'] +  '）}\n'
        self.sideMd = self.sideMd + '\LimeCVCustomEnd{cvInterests}\n'
        
    def language(self, item):
        self.sideMd = self.sideMd + '\LimeCVCustomBegin{cvLanguages}\n'
        for i in item['entrys']:
            self.sideMd = self.sideMd + '\cvLanguage{' + i['item'] + '（' + i['desc'] + '）}{' + str(i['score']) + '}\n'
        self.sideMd = self.sideMd + '\LimeCVCustomEnd{cvLanguages}\n'
            
    def main(self):
        self.sideMd = ""
        self.mainMd = ""
        self.middlmainMd = '\n\LimeCVCustomEnd{cvSidebar}\n\LimeCVCustomBegin{cvMainContent}\n'
        for i in self.spec:
            f = i['type']
            if f == 'education':
                self.entry(i)
            if f == 'experience':
                self.experience(i)
            if f == 'project':
                self.project(i)
            if f == 'cvitem':
                self.cvitem(i)
            if f == 'skill':
                self.skill(i)
            if f == 'interest':
                self.interest(i)
            if f == 'language':
                self.language(i)
        return self.md + self.sideMd + self.middlmainMd + self.mainMd
 
if __name__ == '__main__':
    cv = LimeCV(sys.argv[1])
    md = cv.main()
    print(md)