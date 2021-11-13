from music21 import *
import os
import serial
import time
import random

start = time.time() 


arduino = serial.Serial(port='/dev/cu.SLAB_USBtoUART', baudrate=115200, timeout=.1)
def write(x):
    arduino.write(x.encode("utf-8"))


fp = 'ballade1.mid'
mf = midi.MidiFile()
mf.open(fp)
mf.read()
mf.close()
len(mf.tracks)
s = midi.translate.midiFileToStream(mf)
measures = s.getElementsByClass(stream.Part)[0].getElementsByClass(stream.Measure)
bpm = 100.0

for i,m in enumerate(measures):
    v =  m.getElementsByClass(stream.Voice)
    if len(v) > 0:
        m = v[0]
    for elem in m:
        currtime = time.time()
        if 'tempo' in elem.classes or 'MetronomeMark' in elem.classes:
            bpm = elem.number
            print(bpm)
        if 'Note' in elem.classes:
            write("0," + elem.name + ":" + str(elem.octave) + "\n")
        elif 'Chord' in elem.classes:
            pitchstr = ''
            for pitch in elem.pitches:
                if pitchstr == '':
                    pitchstr += pitch.name + ":" + str(pitch.octave)
                else:
                    pitchstr += "," + pitch.name + ":" + str(pitch.octave)
                write("1," + str(len(elem.pitches)) + ",'" + pitchstr + "\n")

        elif 'Rest' in elem.classes:
            write("2" + "\n")
        
        print(elem, elem.duration.quarterLength * (60.0 / bpm))
        while(1):
            if(time.time() - currtime > elem.duration.quarterLength * (60.0 / bpm)):
                break

# # measures[239].show()
