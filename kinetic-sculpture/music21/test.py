from music21 import *
import os
import serial
import time
start = time.time() 

# file = converter.parse('ballade1.mid')
# os.system('echo "" > score')

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
# print(s.getElementsByClass(stream.Part)[0].getElementsByClass(stream.Tempo))
bpm = 100.0
# print(bpm)
#bpm = 142.0
# b = 60.0 / bpm
# print(b)

for i,m in enumerate(measures):
    # print(i+1, m, m.offset)
    # m = m.getElementsByClass(stream.Voice)[0]
    v =  m.getElementsByClass(stream.Voice)
    if len(v) > 0:
        m = v[0]
    # print("notes", len(m.getElementsByClass(note.Note)))
    # print("chords", len(m.getElementsByClass(chord.Chord)))
    # print("rests", len(m.getElementsByClass(note.Rest)))
    for elem in m:
        currtime = time.time()
        if 'tempo' in elem.classes or 'MetronomeMark' in elem.classes:
            bpm = elem.number
            print(bpm)
        if 'Note' in elem.classes:
            # print("i am a note")
            # write(str(elem.offset + m.offset) + ",note," + elem.name + ":" + str(elem.octave))
            write("0," + elem.name + ":" + str(elem.octave) + "\n")
        elif 'Chord' in elem.classes:
            # print("I am a chord")
            pitchstr = ''
            for pitch in elem.pitches:
                # print("i am a note in a chord", elem.offset + m.offset)
                # print(pitch.name, pitch.octave)
                if pitchstr == '':
                    pitchstr += pitch.name + ":" + str(pitch.octave)
                else:
                    pitchstr += "," + pitch.name + ":" + str(pitch.octave)
                #write(str(elem.offset + m.offset) +  ",chord," + pitchstr)
                write("1," + pitchstr + "\n")

        elif 'Rest' in elem.classes:
            # print("I am a rest", elem.offset + m.offset)
            # write(str(elem.offset + m.offset) + ",rest")
            write("2" + "\n")
        
        print(elem, elem.duration.quarterLength * (60.0 / bpm))
        # os.system('echo '+ str(elem) + "," + elem.offset + '>> score')
        while(1):
            if(time.time() - currtime > elem.duration.quarterLength * (60.0 / bpm)):
                break

# # measures[239].show()


# def write(x):
#     arduino.write(bytes(x, 'utf-8'))
    # time.sleep(0.05)
    # data = arduino.readline()
    # return data


# while True:
#     num = input("Enter a number: ") # Taking input from user
#     value = write_read(num)
#     print(value) # printing the value
