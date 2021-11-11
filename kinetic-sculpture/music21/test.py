from music21 import *
import os
import serial
import time
start = time.time() 

# file = converter.parse('ballade1.mid')
os.system('echo "" > score')

fp = 'ballade1.mid'
mf = midi.MidiFile()
mf.open(fp)
mf.read()
mf.close()
len(mf.tracks)
s = midi.translate.midiFileToStream(mf)
measures = s.getElementsByClass(stream.Part)[0].getElementsByClass(stream.Measure)
# print(s.getElementsByClass(stream.Part)[0].getElementsByClass(stream.Tempo))

bpm = 142.0
b = 60.0 / 142.0
# print(b)

for i,m in enumerate(measures):
    print(i+1, m, m.offset)
    # m = m.getElementsByClass(stream.Voice)[0]
    v =  m.getElementsByClass(stream.Voice)
    if len(v) > 0:
        m = v[0]
    print("notes", len(m.getElementsByClass(note.Note)))
    print("chords", len(m.getElementsByClass(chord.Chord)))
    print("rests", len(m.getElementsByClass(note.Rest)))
    for elem in m:
        if 'Note' in elem.classes:
            print("i am a note")
            print(elem.name, elem.octave, elem.offset + m.offset)
        elif 'Chord' in elem.classes:
            print("I am a chord")
            for pitch in elem.pitches:
                print("i am a note in a chord", elem.offset + m.offset)
                print(pitch.name, pitch.octave)
        elif 'Rest' in elem.classes:
            print("I am a rest", elem.offset + m.offset)
        # print(elem, elem.offset)
        # os.system('echo '+ str(elem) + "," + elem.offset + '>> score')

# # measures[239].show()


# arduino = serial.Serial(port='/dev/cu.SLAB_USBtoUART', baudrate=115200, timeout=.1)
# def write_read(x):
#     arduino.write(bytes(x, 'utf-8'))
#     time.sleep(0.05)
#     data = arduino.readline()
#     return data
# while True:
#     num = input("Enter a number: ") # Taking input from user
#     value = write_read(num)
#     print(value) # printing the value
