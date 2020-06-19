#!/usr/bin/env python3
from os import listdir
from os.path import isfile, isdir
from sys import argv

def get_folderstructure(thedir):
    data = []
    for i in listdir(thedir):
        fpath = thedir+ "/" +i
        if(isfile(fpath)):
            data.append(fpath)
        else:
            data.append(("{}".format(fpath),get_folderstructure(fpath)))
    data.reverse()
    return data

def trim(s):
    sp = s.split()
    chs = []
    append=False
    for i in s:
        if i == '/':
            chs = []
            append=True
        elif i == '.':
            append=False
        elif append:
            chs.append(i)
    return "".join(chs)

def parse(data):
    out_str = ""
    for d in data:
        if type(d) == tuple:
            out_str += "\t\t\t\t\t\t<h3>{}</h3>\n".format(trim(d[0]))
            out_str += parse(d[1])
        else:
            with open(d, "r") as fil:
                for line in fil.readlines():
                    out_str += "\t\t\t\t\t\t{}".format(line)
    return out_str

wfiles = []
index_html = ""
links_html = ""
for i in listdir(argv[1]):
    fpath=argv[1]+"/"+i
    if(isdir(fpath)):
        data = get_folderstructure(fpath)
        links_html+="\t\t\t\t\t<div class=\"subbox sansserif layer3\">\n"
        links_html+=parse(data)
        links_html+="\t\t\t\t\t</div>\n"
    else:
        wfiles.append(fpath)

print(links_html)
