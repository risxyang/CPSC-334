from gpiozero import Button
button = Button(22)

button.wait_for_press()
print('You pushed me')
