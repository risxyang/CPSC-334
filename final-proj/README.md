# Module 7 for CPSC 334: Creative Embedded Systems #

Final project! "Intervals" is an interactive projection system comprising an XY-photoresistor-sensorpad, a sculptural piece, and a projector velcroed to the ceiling. 

Video Link:
https://vimeo.com/658758763 


<p align="center">
<img src="https://github.com/risxyang/CPSC-334/blob/main/final-proj/img.jpg" width="450px" height ="auto" alt="photograph of forest-y sculpture in a rectangular prism frame lit up by purple leds, sketch of a bird projected down next to it">
</p>


## Installation ##
- 3 ESP32s (one for LEDs, one for 5 photoresistors, one for the other 4 photoresistors. A max # of 6 ADC1 pins can be used over wifi for a single ESP.)
- Solderless breadboard, wires, resistors (9x 10k Ohm for photoresistors, 3x 220 Ohm for LEDs)
- 9 ambient light sensors
- 3 tricolor LEDs
- Enclosures
    - laser-cut pieces for the sculpture frame and sensorpad enclosure (corel draw file for both of these is in this directory as "enclosure.cdr")
    - paint (unless you like the toasty freshly-laser-cut wood aesthetic)
- For visual output: a Raspberry Pi + (Pocket) Projector 
- Velcro straps + tape (to get the projector on the ceiling!)
- Portable battery packs (for the ESPs; alternatively you could wire up batteries yourself)
- A dark(ish) room
- Lamp for the sensorpad

This program runs on Processing, and a version of this program is compatible with version 3.5.3 which runs on a Raspberry Pi. If you want to run this program, you can download processing onto your pi. One option is to run this in your raspi terminal:

`curl https://processing.org/download/install-arm.sh | sudo sh`

Alternatively, you can do this manually:

`cd ~
wget http://download.processing.org/processing-3.5.3-linux-armv6hf.tgz
tar xvfz processing-3.5.3-linux-armv6hf.tgz`

This will download the 3.5.3 release to your home directory and then extract it. 

For Raspberry Pi, download the final_raspi_vers folder in this directory. On your machine, navigate to the directory where you've downloaded this file, and run this command to copy it over to the sketchbook folder so processing can locate it:

`cp final_raspi_vers /home/pi/sketchbook/sketches/`

If there was not already a /sketchbook/sketches directory on your pi, you can create one with mkdir.

Finally, navigate to where processing is installed on your machine and run the command to set visual output to your HDMI display:

`cd ~/processing-3.5.3
DISPLAY=:0 ./processing-java --sketch=/home/pi/sketchbook/sketches/night_sky--present`

This will run your code without needing the processing editor, and can be done over ssh if you don't have a keyboard plugged in to your raspi. 

Finally, you'll also want to download the Arduino IDE so you can compile and upload code which handles sensor input to the ESP32s.

- under /led_analogwrite/ is a .ino file in which you can define your GPIO pin setup (currently runs on adjacent triples (5,18,19), (15,2,0) and (33,25,26))
- under /light_sensor_wifi_set1/ is an .ino file in which you can define your GPIO pin setup (for the first 5 photoresistors) and the IP address of a server to which your ESP32 will send the sensor information. 
- under /light_sensor_wifi_set2/ is an .ino file for the other 4 photoresistors; same deal as above!

In this directory are two python server files (server.py; server2.py) you will need to receive sensor data on your machine. Update the IP address to which you are binding the socket to that of your machine. The servers write to two text files which are read by Processing to get the most recent batch of sensor data. 
Sensor data comes in the form of CSR analog reads. 

To set this program to run on boot, add the following lines of code to the end of ~/.profile on your pi:
```
python3 [path to your server.py file]
cd ~/processing-3.5.3
DISPLAY=:0 ./processing-java --sketch=/home/pi/sketchbook/sketches/night_sky --present 
```

## Notes on Functionality ##
- The projection shifts through "day" and "night" intervals
- The placement of photoresistors on the sensorpad correspond to the cardinal directions
- At "night," a visitor may move their hand over the sensorpad; the projection will respond, orienting itself towards the direction with the deepest shadow cast on it.

