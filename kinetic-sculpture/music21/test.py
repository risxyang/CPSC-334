from music21 import *
import os
import serial
import time
import random
import math

start = time.time() 

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



s_ang = 0.0
e_ang = 0.0
w_ang = 0.0

for i,m in enumerate(measures):
    v =  m.getElementsByClass(stream.Voice)
    if len(v) > 0:
        m = v[0]
    for elem in m:
        currtime = time.time()
        #duration in seconds
        dur = elem.duration.quarterLength * (60.0 / bpm)

        if 'tempo' in elem.classes or 'MetronomeMark' in elem.classes:
            bpm = elem.number
            print(bpm)
        if 'Note' in elem.classes:
            #0, noteindex, octave #
            # write("0," + str(noteIndex[elem.name]) + "," + str(elem.octave) + "\n")

            #calc shoulder angle
            s_ang = (90.0 / 7.0) * elem.octave
            #calc elbow angle
            e_ang = get_elbow_angle_from_shoulder_angle(s_ang, noteIndex[elem.name])
            #calc wrist angle
            w_ang = 0.0

            # print(s_ang, e_ang, w_ang)
            write(str(dur) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "\n")
        elif 'Chord' in elem.classes:
            # pitchstr = ''
            # for pitch in elem.pitches:
            #     if pitchstr == '':
            #         pitchstr += str(noteIndex[pitch.name]) + ":" + str(pitch.octave)
            #     else:
            #         pitchstr += "," + pitch.name + ":" + str(pitch.octave)
            # write("1," + str(len(elem.pitches)) + ",'" + pitchstr + "\n")

            #for this version of the program: send the lowest and highest notes within the chord
            n = len(elem.pitches)
            note1_index = noteIndex[elem.pitches[0].name]
            octave1 = elem.pitches[0].octave
            note2_index = noteIndex[elem.pitches[n-1].name]
            octave2 = elem.pitches[n-1].octave

            #first set of angles
            s_ang = (90.0 / 7.0) * octave1  #calc shoulder angle
            e_ang = get_elbow_angle_from_shoulder_angle(s_ang, note1_index) #calc elbow angle
            w_ang = 0.0 #calc wrist angle
            write(str(dur / 2.0) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "\n")
            while(1):
                if(time.time() - currtime > (dur / 2.0)):
                    break
            #second set of angles
            s_ang = (90.0 / 7.0) * octave2  #calc shoulder angle
            e_ang = get_elbow_angle_from_shoulder_angle(s_ang, note2_index) #calc elbow angle
            w_ang = 0.0 #calc wrist angle
            write(str(dur / 2.0) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "\n")

            #1, noteindex1, octave#1, noteindex2, octave#2
            #write("1," + str(noteIndex[elem.pitches[0].name]) + "," + str(elem.pitches[0].octave) + "," + str(noteIndex[elem.pitches[n-1].name]) + "," + str(elem.pitches[n-1].octave) + "\n")

        elif 'Rest' in elem.classes:
            # write("2" + "\n")
            w_ang = 80.0
            write(str(dur) + "," + str(int_inrange(s_ang, 180, 3000)) + "," + str(int_inrange(e_ang, 180, 3000)) + "," + str(int_inrange(w_ang, 180, 3000)) + "\n")
        
        # print(elem, elem.duration.quarterLength * (60.0 / bpm))
        # print(elem)
        while(1):
            if(time.time() - currtime > elem.duration.quarterLength * (60.0 / bpm)):
                break

# # measures[239].show()
