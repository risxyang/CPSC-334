from music21 import *
import argparse
import os
import serial
import time
import random
import math
import requests
import lxml
import lxml.html as lh
import pandas as pd
# from gpiozero import Button
import pyOSC3
import sys

#SUPERCOLLIDER
client = pyOSC3.OSCClient()
client.connect( ( '127.0.0.1', 57120 ) )

# button = Button(13) #switch

start = time.time() 

def make_hashmap_of_notefreqs():
    #webscrape note freqs
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

    # print(noteFreq)
    return noteFreq

noteIndex = {
    "C":1,
    "C#":2,
    "D-":2,
    "D":3,
    "D#":4,
    "E-":4,
    "E":5,
    "F":6,
    "F#":7,
    "G-":7,
    "G":8,
    "G#":9,
    "A-":9,
    "A":10,
    "A#":11,
    "B-":11,
    "B":12
}

br = 115200

arduino = serial.Serial(port='/dev/cu.SLAB_USBtoUART', baudrate=br, timeout=.1)

def write(x):
    arduino.write(x.encode("utf-8"))


def writeSC(x):
    msg = pyOSC3.OSCMessage()
    msg.setAddress("/print")
    msg.append(x)
    client.send(msg)


def get_elbow_angle_from_shoulder_angle(s_ang, note_index):
    a = s_ang
    h = 5.75 * math.cos(math.radians(90.0 - a))
    h2 = 6.5 - h
    x = (h2 * 5.75) / h
    sin_a_minus_b = (x * (math.sin(math.radians(180.0 - a)))) / 5.75
    a_minus_b = math.asin(sin_a_minus_b)
    a_minus_b  = math.degrees(a_minus_b)
    b = a - (a_minus_b)
    #print("b " + str(b))
    e_ang = (((180.0 - b )/ 12.0) * note_index) + b
    if e_ang < 0:
        e_ang = 0.0
    return e_ang

def int_inrange(x, old_upper, new_upper):
    newx = round(x * new_upper / old_upper)
    return newx


def read_switch_val():
    data = arduino.read(1)
    data += arduino.read(arduino.inWaiting())
    switch = data.decode('utf-8').strip()
    return switch


def main(path_to_midi_file, robo):
    #get notefreqs
    noteFreq = make_hashmap_of_notefreqs()

    fp = path_to_midi_file
    mf = midi.MidiFile()
    mf.open(fp)
    mf.read()
    mf.close()
    len(mf.tracks)
    s = midi.translate.midiFileToStream(mf)
    measures = s.getElementsByClass(stream.Part)[0].getElementsByClass(stream.Measure)
    bpm = 100.0

    s_ang = 0.0
    e_ang = 0.0
    w_ang = 0.0
    writeSC(0)

    for i,m in enumerate(measures):
        v =  m.getElementsByClass(stream.Voice)
        if len(v) > 0:
            m = v[0]
        for elem in m:
            #check for interruptions
            currtime = time.time()
            #duration in seconds
            dur = elem.duration.quarterLength * (60.0 / bpm)
            switch = read_switch_val()
            switch = "1"
            if 'tempo' in elem.classes or 'MetronomeMark' in elem.classes:
                bpm = elem.number
                #print(bpm)
            if 'Note' in elem.classes:
                if len(switch) > 0 and int(switch[0]) == 1:
                    #calc shoulder angle
                    s_ang = (90.0 / 7.0) * elem.octave
                    #calc elbow angle
                    e_ang = get_elbow_angle_from_shoulder_angle(s_ang, noteIndex[elem.name])
                    #calc wrist angle
                    w_ang = 0.0

                # print(s_ang, e_ang, w_ang)
                write(str(dur) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "\n")
                if(robo == True):
                    writeSC(noteFreq[str(elem.name) + str(elem.octave)])
                else:
                    writeSC("1,"+ str(dur) + "," + str(noteFreq[str(elem.name) + str(elem.octave)]))
            elif 'Chord' in elem.classes:
                pitchstr = ''
                for pitch in elem.pitches:
                    if pitchstr == '':
                        pitchstr += str(noteFreq[str(pitch.name) + str(pitch.octave)])
                    else:
                        pitchstr += "," + str(noteFreq[str(pitch.name) + str(pitch.octave)])
                # write("1," + str(len(elem.pitches)) + ",'" + pitchstr + "\n")
                if(robo == False):
                    writeSC(str(len(elem.pitches)) + "," + str(dur) + "," + pitchstr)

                #for this version of the program: send the lowest and highest notes within the chord
                n = len(elem.pitches)
                note1_index = noteIndex[elem.pitches[0].name]
                octave1 = elem.pitches[0].octave
                note2_index = noteIndex[elem.pitches[n-1].name]
                octave2 = elem.pitches[n-1].octave

                if len(switch) > 0 and int(switch[0]) == 1:
                #first set of angles
                    s_ang = (90.0 / 7.0) * octave1  #calc shoulder angle
                    e_ang = get_elbow_angle_from_shoulder_angle(s_ang, note1_index) #calc elbow angle
                    w_ang = 0.0 #calc wrist angle
                write(str(dur / 2.0) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "\n")
                if robo == True:
                    writeSC(noteFreq[str(elem.pitches[0].name) + str(elem.pitches[0].octave)]) 
                while(1):
                    if(time.time() - currtime > (dur / 2.0)):
                        break
                
                if len(switch) > 0 and int(switch[0]) == 1:
                #second set of angles
                    s_ang = (90.0 / 7.0) * octave2  #calc shoulder angle
                    e_ang = get_elbow_angle_from_shoulder_angle(s_ang, note2_index) #calc elbow angle
                    w_ang = 0.0 #calc wrist angle
                write(str(dur / 2.0) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "\n")
                if robo == True:
                    writeSC(noteFreq[str(elem.pitches[n-1].name) + str(elem.pitches[n-1].octave)])
            elif 'Rest' in elem.classes:
                # write("2" + "\n")
                if len(switch) > 0 and int(switch[0]) == 1:
                    w_ang = 80.0
                write(str(dur) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "\n")
                # writeSC(0)

            # print(elem, elem.duration.quarterLength * (60.0 / bpm))
            # print(elem)
            while(1):
                if(time.time() - currtime > elem.duration.quarterLength * (60.0 / bpm)):
                    break

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('path', type=str, nargs=1,  help='path to midi file')
    parser.add_argument("--robo", help="number of epochs for training",
                        type=bool, default=False)
    args = parser.parse_args()
    main(args.path[0], args.robo)
    sys.exit(0)