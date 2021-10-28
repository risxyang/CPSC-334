# Module 3 Project for CPSC 334: Creative Embedded Systems #

A wireless art installation piece, reflecting on memory and the passage of time.  

Video Links:
https://vimeo.com/639839204 (Digital visual output)
https://vimeo.com/639834601 

<p align="center">
<img src="https://github.com/risxyang/CPSC-334/blob/main/installation-art/images/img1.png"  width="450px" height ="auto" alt="visuals from a processing program">
</p>

## Installation ##
- ESP32
- Solderless breadboard, wires, resistors
- Piezoelectric sensor
- <a href="https://www.bareconductive.com/blogs/resources/make-a-basic-capacitive-sensor-with-electric-paint-and-arduino">DIY Capacitative Touch Sensor</a>
- 4 ambient light sensors
- Enclosure (wooden cube + stand)
- For visual output: either a Raspberry Pi + Projector or some HDMI display

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
DISPLAY=:0 ./processing-java --sketch=/home/pi/sketchbook/sketches/final_raspi_vers --present`


This will run your code without needing the processing editor, and can be done over ssh if you don't have a keyboard plugged in to your raspi. 

(Otherwise, you can simply run the mac version of this program in the editor on your machine -- this will probably work just fine on other systems too, dependent on the version of processing installed-- I have not tested this).

Finally, you'll also want to download the Arduino IDE so you can compile and upload code which handles sensor input to an ESP32. In the wifi_arduino directory is an .ino file, in which you can define your GPIO pin setup and the IP address of a server to which your ESP32 will send the sensor information. You will want to install the <a href="https://playground.arduino.cc/Main/CapacitiveSensor/">capacitative sensor library.</a> 
- If this creates strange errors on compile, you may have to edit the .h file for the library to include the <b> #elif defined(ARDUINO_ARCH_ESP32) </b> section in <a href="https://github.com/PaulStoffregen/OneWire/blob/master/util/OneWire_direct_gpio.h">this header file.</a> This fix was proposed <a href="https://github.com/PaulStoffregen/CapacitiveSensor/issues/24">here.</a>

In this directory is a server.py file you will need to receive sensor data on your machine. Update the IP address to which you are binding the socket to that of your machine. The server writes to a text file which is read by Processing to get the most recent batch of sensor data. Sensor data comes in the form of analog reads of:
- [average sum of all light sensor values at initialization, over 10 successive reads]
- [current sum of all light sensor values]
- [average piezosensor value at initialization, over 10 successive reads]
- [current piezosensor value]
- [average capacitative touch sensor value at initialization, over 10 successive reads]
- [current capacitative touch sensor value]

This setup allows tracking of deviation from the initial state of sensor values, which are set immediately after boot.

To set this program to run on boot, add the following lines of code to the end of ~/.profile on your pi:
```
python3 [path to your server.py file]
cd ~/processing-3.5.3
DISPLAY=:0 ./processing-java --sketch=/home/pi/sketchbook/sketches/final_raspi_vers --present 
```

## General Info on Functionality ##
Notes on interactivity:
- Deviation from the initial light sensor state results in increase of speed of moving light in the visuals; the greater the deviation, the greater the change in speed.
- Jostling the box, picking it up, holding the box on or near the side of the touch sensor, and generally causing any vibration to the structure will cause the moving light to disappear.

<p align="center">
<img src="https://github.com/risxyang/CPSC-334/blob/main/installation-art/images/img4.jpg" alt="cube and stand enclosure on a table as visuals are projected onto them and the wall behind them">
</p>

