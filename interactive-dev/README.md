# Module 2 Task 2 for CPSC 334: Creative Embedded Systems #

An interactive and exploratory audio-visual experience.

<img src="https://github.com/risxyang/CPSC-334/blob/main/interactive-dev/img.jpg"  width="400px" height ="auto" alt="image of esp32 in clear enclosure with visible, colorful wires, a raspberry pi plugged in to a 5inch hdmi screen displaying multicolored dots">


Video Link: https://vimeo.com/626151679

## Installation ##

Materials:
- Raspberry Pi
- ESP32
- Solderless breadboard, wires
- Analog Joystick
- Momentary Button
- SPST Switch
- Bluetooth speaker
- HDMI display (5 inch), HDMI cable 
- Enclosure (made from take-out containers)

This program runs on Processing, and is compatible with version 3.5.3 which runs on a Raspberry Pi. If you want to run this program, you can download processing onto your pi. One option is to run this in your raspi terminal:

`curl https://processing.org/download/install-arm.sh | sudo sh`

Alternatively, you can do this manually:

`cd ~
wget http://download.processing.org/processing-3.5.3-linux-armv6hf.tgz
tar xvfz processing-3.5.3-linux-armv6hf.tgz`

This will download the 3.5.3 release to your home directory and then extract it. 

Download the dotgame folder under task 2; navigate to the directory it is in, and run this command to copy it over to the sketchbook folder so processing can locate it:

`cp dotgame /home/pi/sketchbook/sketches/`

If there was not already a /sketchbook/sketches directory on your pi, you can create one with mkdir.

Finally, navigate to where processing is installed on your machine and run the command to set visual output to your HDMI display:

`cd ~/processing-3.5.3
DISPLAY=:0 ./processing-java --sketch=/home/pi/sketchbook/sketches/dotgame --present 
`

This will run your code without needing the processing editor, and can be done over ssh if you don't have a keyboard plugged in to your raspi. 

If audio output does not work, you may have to reinstall PySynth, a library which has been downloaded and included in this processing project folder. Enter the Pysynth directory (cd PySynth if you are already in dotgame) and run

`python3 setup.py install`

You can always reclone this version of the PySynth library by running

`git clone git@github.com:mdoege/PySynth.git`

More on this library here: https://github.com/mdoege/PySynth

Finally, you'll also want to download the Arduino IDE so you can compile and upload code to an ESP32. Under /reference/test_allinputs is an .ino file, in which you can define your GPIO pin setup. This will enable your ESP32 to send information through a port (likely '/dev/ttyUSB0' on your pi) with baudrate 115200. The processing file is set up to receive information from this port at this baudrate (in the form of digital reads of [joystick x], [joystick y], [joystick button], [button], [switch]). If your ESP32 happens to communicate over a different port on your pi, you can specify this in the processing file by setting String portName in setup().

## General Info on Functionality ##

This processing program will write to a .py file, set it to be executable, and then use PySynth to generate a .wav file, which is then played with 'aplay.' This will happen every time a certain input is given. 