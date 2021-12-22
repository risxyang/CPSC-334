import socket
import os

# create an INET, STREAMing socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# bind the socket to a public host, and a well-known port
s.bind(("172.29.20.76", 8092))
#s.bind(("172.27.128.205", 8090))
# become a server socket
s.listen(0)

#open file



while True:
    # fp = open("wifiread", "w")
    # accept connections from outside
    (cs, addr) = s.accept()
    # now do something with the clientsocket
    content = cs.recv(1024).decode("utf-8")
    print(content)
    os.system('echo '+ content + '> /home/pi/sketchbook/sketches/wifiread2')
    # cs.send(content.encode())
    content = 0
client.close()
