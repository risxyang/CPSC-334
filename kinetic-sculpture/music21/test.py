from music21 import *
import os

# file = converter.parse('ballade1.mid')

fp = 'ballade1.mid'
mf = midi.MidiFile()
mf.open(fp)
mf.read()
mf.close()
len(mf.tracks)
s = midi.translate.midiFileToStream(mf)
measures = s.getElementsByClass(stream.Part)[0].getElementsByClass(stream.Measure)
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
        print(elem, elem.offset)
    # m.show('text')
