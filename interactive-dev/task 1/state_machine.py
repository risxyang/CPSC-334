from gpiozero import Button
import os

j_sw = Button(22) #click (downwards pressure) on analog joystick
j_y = Button(27) #y axis of analog joystick
j_x = Button(17) #x axis of the analog joystick
b = Button(16, hold_time = 5) #momentary button
s = Button(26) #toggle switch

state = 0 #start off state machine
# state 0: switch off
# state 1: switch on; toggling joystick decrements x/y vals
#state 2: switch on, button held: toggling joystick increments x/y vals

b_prevstate = 0
s_prevstate = 0
j_x_prevstate = 0
j_y_prevstate = 0
j_sw_prevstate = 0

val_x = 0
val_y = 0

def shutdown(): #exit program
	print("Button pressed: exiting")
	os._exit(0)

if s.value == 0:
	state = 0
	print("Current State: 0: Started with switch off")
else:
	state = 1
	s_prevstate = 1
	print("Current State: 1: Started with switch on")

while True: 
	if state == 0:
		if s.value == 1 and s_prevstate != 1:
			state = 1
			s_prevstate = 1 #mark switch as turned on
			print("Switch on: transitioning to state 1")
			print("Current state: 1")
		elif s.value == 0 and s_prevstate != 0:
			state = 0
			s_prevstate = 0 #mark switch as turned off
			print("Switch off: transitioning to state 0")
			print("Current State: 0")
		elif j_x.value == 1 and j_x_prevstate != 1:
			j_x_prevstate = 1 #mark j_x as having been toggled to
			print("Joystick locked")
		elif j_x.value == 0 and j_x_prevstate != 0:
			j_x_prevstate = 0 #mark j_x as having been released
		elif j_y.value == 1 and j_y_prevstate != 1:
			j_y_prevstate = 1 #mark j_y as having been toggled to
			print("Joystick locked")
		elif j_y.value == 0 and j_y_prevstate != 0:
			j_y_prevstate = 0 #mark j_y as having been released
		else: #check if button's been held for specified number of seconds
			b.when_held = shutdown #call shutdown function
	elif state == 1:
		if s.value == 0 and s_prevstate != 0:
			state = 0
			s_prevstate = 0 #mark switch as turned off
			print("Switch off: transitioning to state 0")
			print("Current State: 0")
		elif j_sw.value == 1 and j_sw_prevstate != 1:
			val_x = 0
			val_y = 0
			j_sw_prevstate = 1 #mark j_sw as having been pressed
			print("Reset Values: x and y are: ", val_x, val_y)
		elif j_sw.value == 0 and j_sw_prevstate != 0:
			j_sw_prevstate = 0 #mark j_sw as having been released
		elif b.value == 1 and b_prevstate !=1:
			state = 2
			b_prevstate = 1 #mark button as being pressed
			print("Button pressed: transitioning to state 2")
			print("Current State: 2")
		else: #we are in state 1 and there was no transition this time around
			if j_x.value == 1 and j_x_prevstate != 1:
				j_x_prevstate = 1 #mark joystick x as having just been toggled
				val_x -= 1
				print("Values of x and y are: ", val_x, val_y)
			elif j_x.value == 0 and j_x_prevstate !=0:
				j_x_prevstate = 0 #mark joystick x as having just been released
			elif j_y.value == 1 and j_y_prevstate !=1:
				j_y_prevstate = 1 #mark joystick y as just having been toggled
				val_y -= 1
				print("Values of x and y are: ", val_x, val_y)
			elif j_y.value == 0 and j_y_prevstate != 0:
				j_y_prevstate = 0 #mark joystick y as just having been released
	elif state == 2:
		if s.value == 0 and s_prevstate != 0:
                        state = 0
                        s_prevstate = 0 #mark switch as turned off
                        print("Switch off: transitioning to state 0")
                        print("Current State: 0")
		elif j_sw.value == 1 and j_sw_prevstate != 1:
			val_x = 0
			val_y = 0
			j_sw_prevstate = 1 #mark j_sw as having been pressed
			print("Reset Values: x and y are: ", val_x, val_y)
		elif j_sw.value == 0 and j_sw_prevstate != 0:
                	j_sw_prevstate = 0 #mark j_sw as having been released
		elif b.value == 0 and b_prevstate != 0:
			state = 1
			b_prevstate = 0 #mark button as no longer pressed
			print("Button released: transitioning to state 1")
			print("Current State: 1")
		else: #we are in state 2 and there was no transition this time around
			if j_x.value == 1 and j_x_prevstate != 1:
				j_x_prevstate = 1 #mark joystick x as having just been toggled
				val_x += 1
				print("Values of x and y are: ", val_x, val_y)
			elif j_x.value == 0 and j_x_prevstate !=0:
				j_x_prevstate = 0  #mark joystick x as having just been released
			elif j_y.value == 1 and j_y_prevstate !=1:
				j_y_prevstate = 1 #mark joystick y as just having been toggled
				val_y += 1
				print("Values of x and y are: ", val_x, val_y)
			elif j_y.value == 0 and j_y_prevstate != 0:
				j_y_prevstate = 0 #mark joystick y as just having been released

