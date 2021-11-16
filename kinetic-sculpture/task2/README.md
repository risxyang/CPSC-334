# Module 4 Project for CPSC 334: Creative Embedded Systems #

An abstract-art-generating-midi-sound-file-visualizing-brachiograph-program

Video Link:
https://vimeo.com/646330699


<p align="center">
<img src="https://github.com/risxyang/CPSC-334/blob/main/kinetic-sculpture/images/M4.png" alt="brachiograph image">
</p>

## Installation ##

Materials:
- ESP32
- Solderless breadboard, wires, resistors
- 3 Servo motors
- SPST Switch
- 2 Popsicle Sticks
- 1 Clothespin
- 1 Pen (or other writing, drawing, painting tools)
- Enclosure (plastic project box)
- Laptop to run Supercollider, if you want audio 

Under /read_music_input is an .ino file, in which you can define your preferred GPIO setup for the three servo motors; this script has been tested with an ESP32.

You can download and then manually run either supercollider script, which will sonify the midi file as it is being parsed: 'robosonify.scd' or 'sonify.scd.' The former is named that way because my sister listened to a video of it and said "it sounds robotic." 

Lastly, the "readmidi.py" script will read in any midi file (whose filepath you can specify), delivering instructions to motors which correspond to notes as they are parsed. <a href="https://web.mit.edu/music21/"> Music21 </a>was used for reading in MIDI files, and its installation directions can be found <a href="https://web.mit.edu/music21/doc/installing/index.html">at this link.</a>

Arguments for this script can optionally be specified:
- robo: if you are using robosonify.scd, you should set --robo True! this gets the note frequency information in the right format to Supercollider
- loops: False will play through the piece at its own tempo; the brachiograph's shoulder will move according to current note octave and its elbow will move according to current note index within a single octave. --loops True will add some circularity to the drawn shapes.
- loopdur(ation) (seconds): if loops = True, then you can prolong the length for which the brachiograph draws with a single note's qualities before moving onto the next. 
- delay (ms): if loops = True, you can specify the motor delay you want; longer delays ==> the brachiograph draws slower; completes less loops for each note

```
python3 readmidi.py path-to-midi-file [--robo True/False] [--loops True/False] [--loopdur Integer] [--delay Integer]
```

For example,
```
python3 readmidi.py midi_files/ballade4.mid --robo True --loops True --loopdur 5 --delay 20
```

You can experiment with different midi files and different values for each of these arguments! 

Note: It's possible this will work with any MIDI file, but only solo piano compositions were used in testing this device. Most files were downloaded from <a href="http://www.piano-midi.de/"> piano-midi.de. </a>

Tested with:
- <a href="https://yamahaden.com/midi-files/category/chopin_fr%C3%A9d%C3%A9ric_balladeno_4infminor_op_52_611406398">Chopin: Ballade No. 4 in F Minor , Op. 52 -- performance by Arthur Khmara</a>
- <a href="https://yamahaden.com/midi-files/category/chopin_fr%C3%A9d%C3%A9ric_balladeno_1ingminor_op_23_1714475151">Chopin: Ballade No. 1 in G Minor , Op. 23-- performance by Ryan McNamara</a>
- <a href="http://www.piano-midi.de/chopin.htm">Chopin: Grande Valse Brillante, Opus 18</a>
- <a href="http://www.piano-midi.de/liszt.htm">Liszt: Grandes Etudes de Paganini, No. 6</a>
- <a href="http://www.piano-midi.de/rach.htm">Rachmaninoff: 13 Préludes, Opus 32, No. 1 </a>
- <a href="http://midisheetmusic.com/songs.html"> Bach: Invention 13 in A Minor, BWV 784 </a>