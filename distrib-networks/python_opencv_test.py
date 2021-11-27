import cv2
import os


cv2.namedWindow("preview")
# cv2.namedWindow("preview", cv2.WND_PROP_FULLSCREEN)
# cv2.setWindowProperty("preview", cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
vc = cv2.VideoCapture(0)

if vc.isOpened(): # try to get the first frame
    rval, frame = vc.read()
else:
    rval = False

while rval:
    # Convert into grayscale
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    msg = str(frame.shape[0]) + "," + str(frame.shape[1])
    os.system('echo '+ msg + '> dims')

    # Detect faces
    faces = face_cascade.detectMultiScale(gray, 1.1, 4)

    msg = ""
    msg += str(len(faces)) + ","
    # Draw rectangle around the faces
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), 2)
        msg += str(x) + "," + str(y) + "," + str(w) + "," + str(h) + ","
    #send to processing
    os.system('echo '+ msg + '> faceread')
    

    cv2.imshow("preview", frame)
    rval, frame = vc.read()
    key = cv2.waitKey(20)
    if key == 27: # exit on ESC
        break

vc.release()
cv2.destroyWindow("preview")