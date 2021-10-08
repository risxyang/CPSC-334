from gpiozero import Button

button = Button(26)

button.wait_for_press()
print("switch on")
button.wait_for_release()
print("switch off")
