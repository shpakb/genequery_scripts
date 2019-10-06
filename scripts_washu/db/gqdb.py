import os
from os import listdir
from os.path import isfile, join
import re
import sys 

pathIn = sys.argv[1]
pathOut = sys.argv[2]

files = listdir(pathIn)

for f in files:
    with open(pathIn+"/"+f) as file:
        #processing text
        text = file.readlines()
        text = [x.strip() for x in text]
        tag = os.path.basename(file.name.replace(".tsv", ""))
        print(tag)
        pairs = []
        module_dict = {}
        for e in text:
            pairs.append([int(s) for s in e.split() if s.isdigit()])
        
        # this really needed to remove NONE from the modules. 
        # Left for compatability with previous versions
        pairs = [[0,0] if (len(e) == 1) else e for e in pairs]
        
        try:
            for e in pairs:
                if e[1] in module_dict:
                    module_dict[e[1]].append(e[0])
                else:
                    module_dict[e[1]] = [e[0]]
        except IndexError:
            pass
        #output
        output_text = ""

        for module in sorted(module_dict.keys()):
            genes_text = ""
            for gene in sorted(module_dict[module], reverse=True):
                genes_text += str(gene) + ","
            output_text += tag + "#" + str(module) + "\t" + genes_text[:-1] + "\n"

        output_file = open(pathOut, "a+")
        output_file.write(output_text)
        output_file.close()
