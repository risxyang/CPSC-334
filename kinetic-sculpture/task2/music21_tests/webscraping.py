import requests
import lxml
import lxml.html as lh
import pandas as pd

url='https://pages.mtu.edu/~suits/notefreqs.html'
#Create a handle, page, to handle the contents of the website
page = requests.get(url)
#Store the contents of the website under doc
doc = lh.fromstring(page.content)
#Parse data that are stored between <tr>..</tr> of HTML
tr_elements = doc.xpath('//tr')

#Check the length of the rows
# print([len(T) for T in tr_elements[1:]])

#make hashmap
noteFreq = {}

for T in tr_elements[1:]:
    key1 = "" #notename
    key2 = "" 
    value = 0.0 #notefreq
    col = 0
    for t in T.iterchildren():
        data=t.text_content().strip()
        if data[0].isalpha():
            if "/" in data:
                notes = data.split("/")
                notes[1] = notes[1].replace('b', '-')
                key1 = notes[0]
                key2 = notes[1]
            else: #just one note
                key1 = data
        elif col == 1:
            value = float(data)
        # try:
        #     data=int(data)
        # except:
        #     pass
        if col == 2:
            # print(key1, key2, value)
            noteFreq[key1] = value
            if key2 != "":
                noteFreq[key2] = value
        col += 1

print(noteFreq)
    
