from gpiozero import Button

button = Button(17)

while True:
  button.wait_for_press()
  print("switch on")
  button.wait_for_release()
  print("switch off")
