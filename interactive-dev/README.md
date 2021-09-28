#Assignment 1 Task 1#

Settings for the switch and the momentary button will dictate the effect of toggling the joystick. 
The joystick modifies the values of two global variables, x and y. These values are printed to the terminal any time they are modified. 

The states/"modes" of operation for this program are as follows:
* State 0: Switch is off
  * Holding the button for 5 seconds will cause the program to exit
  * Toggling the joystick in either direction will show a message saying the joystick is locked
  * Setting the switch to on will trigger the transition to state 1
* State 1: Switch is on
  * Toggling the joystick in the y direction will decrement the value of y
  * Toggling the joystick in the x direction will decrement the value of x
  * Pressing down on the joystick will reset x and y values to 0
  * Holding the button will cause transition to state 2
* State 2: Switch is on, button is held
  * Toggling the joystick in the y direction will increment the value of y
  * Toggling the joystick in the x direction will increment the value of x
  * Pressing down on the joystick will reset x and y values to 0
  * Releasing the button will cause transition to state 1

 
