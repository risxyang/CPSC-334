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

def get_min_elbow_angle(s_ang):
    a = s_ang
    h = 5.75 * math.cos(math.radians(90.0 - a))
    h2 = 6.5 - h
    x = (h2 * 5.75) / h
    sin_a_minus_b = (x * (math.sin(math.radians(180.0 - a)))) / 5.75
    a_minus_b = math.asin(sin_a_minus_b)
    a_minus_b  = math.degrees(a_minus_b)
    b = a - (a_minus_b)
    return b

def get_elbow_angle_from_shoulder_angle(s_ang, note_index):
    b = get_min_elbow_angle(s_ang)
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

noteFreq = {'C0': 16.35, 'C#0': 17.32, 'D-0': 17.32, 'D0': 18.35, 'D#0': 19.45, 'E-0': 19.45, 'E0': 20.6, 'F0': 21.83, 'F#0': 23.12, 'G-0': 23.12, 'G0': 24.5, 'G#0': 25.96, 'A-0': 25.96, 'A0': 27.5, 'A#0': 29.14, 'B-0': 29.14, 'B0': 30.87, 'C1': 32.7, 'C#1': 34.65, 'D-1': 34.65, 'D1': 36.71, 'D#1': 38.89, 'E-1': 38.89, 'E1': 41.2, 'F1': 43.65, 'F#1': 46.25, 'G-1': 46.25, 'G1': 49.0, 'G#1': 51.91, 'A-1': 51.91, 'A1': 55.0, 'A#1': 58.27, 'B-1': 58.27, 'B1': 61.74, 'C2': 65.41, 'C#2': 69.3, 'D-2': 69.3, 'D2': 73.42, 'D#2': 77.78, 'E-2': 77.78, 'E2': 82.41, 'F2': 87.31, 'F#2': 92.5, 'G-2': 92.5, 'G2': 98.0, 'G#2': 103.83, 'A-2': 103.83, 'A2': 110.0, 'A#2': 116.54, 'B-2': 116.54, 'B2': 123.47, 'C3': 130.81, 'C#3': 138.59, 'D-3': 138.59, 'D3': 146.83, 'D#3': 155.56, 'E-3': 155.56, 'E3': 164.81, 'F3': 174.61, 'F#3': 185.0, 'G-3': 185.0, 'G3': 196.0, 'G#3': 207.65, 'A-3': 207.65, 'A3': 220.0, 'A#3': 233.08, 'B-3': 233.08, 'B3': 246.94, 'C4': 261.63, 'C#4': 277.18, 'D-4': 277.18, 'D4': 293.66, 'D#4': 311.13, 'E-4': 311.13, 'E4': 329.63, 'F4': 349.23, 'F#4': 369.99, 'G-4': 369.99, 'G4': 392.0, 'G#4': 415.3, 'A-4': 415.3, 'A4': 440.0, 'A#4': 466.16, 'B-4': 466.16, 'B4': 493.88, 'C5': 523.25, 'C#5': 554.37, 'D-5': 554.37, 'D5': 587.33, 'D#5': 622.25, 'E-5': 622.25, 'E5': 659.25, 'F5': 698.46, 'F#5': 739.99, 'G-5': 739.99, 'G5': 783.99, 'G#5': 830.61, 'A-5': 830.61, 'A5': 880.0, 'A#5': 932.33, 'B-5': 932.33, 'B5': 987.77, 'C6': 1046.5, 'C#6': 1108.73, 'D-6': 1108.73, 'D6': 1174.66, 'D#6': 1244.51, 'E-6': 1244.51, 'E6': 1318.51, 'F6': 1396.91, 'F#6': 1479.98, 'G-6': 1479.98, 'G6': 1567.98, 'G#6': 1661.22, 'A-6': 1661.22, 'A6': 1760.0, 'A#6': 1864.66, 'B-6': 1864.66, 'B6': 1975.53, 'C7': 2093.0, 'C#7': 2217.46, 'D-7': 2217.46, 'D7': 2349.32, 'D#7': 2489.02, 'E-7': 2489.02, 'E7': 2637.02, 'F7': 2793.83, 'F#7': 2959.96, 'G-7': 2959.96, 'G7': 3135.96, 'G#7': 3322.44, 'A-7': 3322.44, 'A7': 3520.0, 'A#7': 3729.31, 'B-7': 3729.31, 'B7': 3951.07, 'C8': 4186.01, 'C#8': 4434.92, 'D-8': 4434.92, 'D8': 4698.63, 'D#8': 4978.03, 'E-8': 4978.03, 'E8': 5274.04, 'F8': 5587.65, 'F#8': 5919.91, 'G-8': 5919.91, 'G8': 6271.93, 'G#8': 6644.88, 'A-8': 6644.88, 'A8': 7040.0, 'A#8': 7458.62, 'B-8': 7458.62, 'B8': 7902.13}

def loopwait(loopmode, loopdur):
    if loopmode:
        loopwaitstart = time.time()
        while(1):
            if(time.time() - loopwaitstart > loopdur):
                break


def main(path_to_midi_file, robo, loopmode, loopdur, delay):
    #get notefreqs
    # noteFreq = make_hashmap_of_notefreqs()

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
                loopwait(loopmode, loopdur)
                if len(switch) > 0 and int(switch[0]) == 1:
                    #calc shoulder angle
                    s_ang = (90.0 / 7.0) * elem.octave
                    #calc elbow angle
                    e_ang = get_elbow_angle_from_shoulder_angle(s_ang, noteIndex[elem.name])
                    e_min = get_min_elbow_angle(s_ang)
                    #calc wrist angle
                    w_ang = 0.0

                # print(s_ang, e_ang, w_ang)
                write(str(dur) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "," + str(loopmode)  + "," + str(delay) + "," + str(int_inrange(e_min, 180, 3000)) + "\n")
                if(robo == True):
                    writeSC(noteFreq[str(elem.name) + str(elem.octave)])
                else:
                    writeSC("1,"+ str(dur) + "," + str(noteFreq[str(elem.name) + str(elem.octave)]))
            elif 'Chord' in elem.classes:
                loopwait(loopmode, loopdur)
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
                    e_min = get_min_elbow_angle(s_ang)
                    w_ang = 0.0 #calc wrist angle
                write(str(dur / 2.0) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "," + str(loopmode) + "," + str(delay) + "," + str(int_inrange(e_min, 180, 3000)) + "\n")
                if robo == True:
                    writeSC(noteFreq[str(elem.pitches[0].name) + str(elem.pitches[0].octave)]) 
                while(1):
                    if(time.time() - currtime > (dur / 2.0)):
                        break
                
                if len(switch) > 0 and int(switch[0]) == 1:
                #second set of angles
                    s_ang = (90.0 / 7.0) * octave2  #calc shoulder angle
                    e_ang = get_elbow_angle_from_shoulder_angle(s_ang, note2_index) #calc elbow angle
                    e_min = get_min_elbow_angle(s_ang)
                    w_ang = 0.0 #calc wrist angle
                write(str(dur / 2.0) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "," + str(loopmode) + "," + str(delay) + "," + str(int_inrange(e_min, 180, 3000)) + "\n")
                if robo == True:
                    writeSC(noteFreq[str(elem.pitches[n-1].name) + str(elem.pitches[n-1].octave)])
            elif 'Rest' in elem.classes:
                # write("2" + "\n")
                if len(switch) > 0 and int(switch[0]) == 1:
                    w_ang = 120.0
                write(str(dur) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "," + str(loopmode) + "," + str(delay) + "\n")
                # writeSC(0)

            print(elem, elem.duration.quarterLength * (60.0 / bpm))
            # print(elem)
            if not loopmode:
                while(1):
                    if(time.time() - currtime > elem.duration.quarterLength * (60.0 / bpm)):
                        break

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('path', type=str, nargs=1,  help='path to midi file')
    parser.add_argument("--robo", help="set to true or false for varying audio",
                        type=bool, default=False)
    parser.add_argument("--loops", help="loopmode!",
                        type=bool, default=False)
    parser.add_argument("--loopdur", help="loop duration in seconds",
                        type=int, default=5)
    parser.add_argument("--delay", help="motor delay in miliseconds",
                        type=int, default=10)
    args = parser.parse_args()

    try:
        main(args.path[0], args.robo, int(args.loops), args.loopdur, args.delay)
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            write("0" + "," + "0" + "," + "0" + "," + "0" + "," + "0" + "," + "0" +  "\n")
            if args.robo == True:
                    writeSC(0)
            sys.exit(0)
        except SystemExit:
            os._exit(0)
    sys.exit(0)